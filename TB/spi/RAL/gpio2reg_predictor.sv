class gpio2reg_predictor_item extends uvm_object;
  // Data fields
  bit [7:0] gpio_in;
  bit [7:0] gpio_in_change;
  bit sts_clear;
  time time_val;

  `uvm_object_utils_begin(gpio2reg_predictor_item)
    `uvm_field_int(gpio_in, UVM_DEFAULT)
    `uvm_field_int(sts_clear, UVM_DEFAULT)
    `uvm_field_int(time_val, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gpio2reg_predictor_item");
    super.new(name);
  endfunction

  // Optional: implement copy, compare, or do_print methods

  virtual function string convert2string();

    return $sformatf(
      "gpio_in=%h clear=%b time_val=%t",
      gpio_in, sts_clear, time_val
    );

  endfunction
endclass

`uvm_analysis_imp_decl(_spi)
`uvm_analysis_imp_decl(_gpio)

class gpio2reg_predictor extends uvm_component;//uvm_subscriber #(gpio_seq_item);
  `uvm_component_utils(gpio2reg_predictor)

  virtual gpio_if gpio_vif;
  spi_reg_block ral;
  //uvm_reg_data_t value;
  bit [7:0] pred_value;
  bit [7:0] irq_sts_pred;
  bit [7:0] gpio_in_old;
  bit irq_value;
  irq_item tr;
  gpio2reg_predictor_item m_pred_tr;
  uvm_analysis_imp_spi #(spi_seq_item, gpio2reg_predictor) spi_item_collected_export;
  uvm_analysis_imp_gpio #(gpio_seq_item, gpio2reg_predictor) gpio_item_collected_export;
  uvm_tlm_fifo #(gpio2reg_predictor_item) m_pred_fifo;
  uvm_analysis_port#(irq_item) irq_ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    spi_item_collected_export  = new("spi_item_collected_export",  this);
    gpio_item_collected_export  = new("gpio_item_collected_export",  this);
    m_pred_fifo = new("m_pred_fifo", this);
    irq_ap = new("irq_ap", this);
    gpio_in_old = '0;
    irq_value = 1'b0;
  endfunction

  function void write_spi(spi_seq_item pkt);
    // read of status should clear register and interrupt
    gpio2reg_predictor_item m_spi_tr;
    if (pkt.write == 1'b0 && pkt.address == 6) begin
      m_spi_tr = new();
      m_spi_tr.sts_clear = 1'b1;
      m_spi_tr.time_val = $time;
      void'(m_pred_fifo.try_put(m_spi_tr));
    end
  endfunction

  function void write_gpio(gpio_seq_item pkt);
    gpio2reg_predictor_item m_gpio_tr;
    if (pkt.gpio_in != gpio_in_old) begin
      m_gpio_tr = new();
      m_gpio_tr.gpio_in = pkt.gpio_in;
      m_gpio_tr.gpio_in_change = gpio_in_old ^ pkt.gpio_in;
      m_gpio_tr.sts_clear = 1'b0;
      m_gpio_tr.time_val = $time;
      gpio_in_old = pkt.gpio_in;
      void'(m_pred_fifo.try_put(m_gpio_tr));
    end
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      m_pred_fifo.get(m_pred_tr);

      if (m_pred_tr.sts_clear == 1'b0) begin // new value on gpio_in

        pred_value = m_pred_tr.gpio_in & ral.input_en.get_mirrored_value();
        irq_sts_pred = (m_pred_tr.gpio_in_change & ral.int_en.get_mirrored_value()) | ral.int_sts.get_mirrored_value();

        void'(ral.gpio_in.bits.predict(
          .value(pred_value),
          .kind(UVM_PREDICT_DIRECT),
          .path(UVM_BACKDOOR)
        ));
        if (ral.int_sts.get_mirrored_value() != irq_sts_pred) begin// there is change in status
          if (irq_value == 1'b0) begin
            irq_value = 1'b1;
            tr = new();
            tr.asserted = 1'b1;
            tr.deaserted = 1'b0;
            tr.time_val = m_pred_tr.time_val;
            irq_ap.write(tr);
          end
        end
        void'(ral.int_sts.bits.predict(
          .value(irq_sts_pred),
          .kind(UVM_PREDICT_DIRECT),
          .path(UVM_BACKDOOR)
        ));
        `uvm_info(get_type_name(), $sformatf("Predicted GPIO_STATUS.gpio_value = 0x%0h", pred_value), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Predicted int_sts.gpio_value = 0x%0h", irq_sts_pred), UVM_HIGH)

      end else begin
        irq_sts_pred = 8'h00;
        //void'(ral.int_sts.bits.predict(
        //  .value(irq_sts_pred),
        //  .kind(UVM_PREDICT_DIRECT),
        //  .path(UVM_BACKDOOR)
        //));
        if (irq_value == 1'b1) begin
            irq_value = 1'b0;
            tr = new();
            tr.asserted = 1'b0;
            tr.deaserted = 1'b1;
            tr.time_val = m_pred_tr.time_val;
            irq_ap.write(tr);
        end
      end
    end
  endtask
endclass
