
class gpio2reg_predictor extends uvm_component;//uvm_subscriber #(gpio_seq_item);
  `uvm_component_utils(gpio2reg_predictor)

  virtual gpio_if gpio_vif;
  spi_reg_block ral;
  //uvm_reg_data_t value;
  bit [7:0] pred_value;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual gpio_if)::get(this, "", "gpio_vif", gpio_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction


//  function void write(gpio_seq_item t);
//
//    // Example:
//    // register GPIO_STATUS contains GPIO input state
//    //
//    // class gpio_status_reg extends uvm_reg;
//    //   rand uvm_reg_field gpio_value;
//    // endclass
//
//    //ral.gpio_status.gpio_value.predict(
//    //  t.gpio_in,
//    //  UVM_PREDICT_DIRECT,
//    //  UVM_BACKDOOR
//    //);
//
//    `uvm_info(get_type_name(),
//      $sformatf("Predicted GPIO_STATUS.gpio_value = 0x%0h", t.gpio_in),
//      UVM_LOW)
//
//  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(gpio_vif.gpio_in);

      pred_value = gpio_vif.gpio_in & ral.input_en.get_mirrored_value();

      void'(ral.gpio_in.bits.predict(
        .value(pred_value),
        .kind(UVM_PREDICT_DIRECT),
        .path(UVM_BACKDOOR)
      ));
      `uvm_info(get_type_name(), $sformatf("Predicted GPIO_STATUS.gpio_value = 0x%0h", pred_value), UVM_HIGH)
    end
  endtask
endclass
