// gpio_in.sv
class data_reg;
	rand bit [7:0] data;
endclass

class gpio_out_RAL_test extends base_test;
  `uvm_component_utils(gpio_out_RAL_test)

  uvm_status_e status;
  logic [7:0] data;
  data_reg data_w;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    clk_rst_sequence m_clk_rst_seq;
    spi_sequence_gpio_out m_spi_seq;
    phase.raise_objection(this);

    m_clk_rst_seq = clk_rst_sequence::type_id::create("clk_rst_seq");
    m_clk_rst_seq.start(m_clk_rst_env.agent.sequencer);

    // try read write SPI transactions to GPIO out, pu and pd registers
    data_w = new ();
    repeat(100) begin
      #(100ns);
      data_w.randomize();
      randcase
        1: begin // GPIO out
          m_spi_env.m_regmodel.gpio_out.write(status, data_w.data);
          m_spi_env.m_regmodel.gpio_out.mirror(status, UVM_CHECK);
          data = m_spi_env.m_regmodel.gpio_out.get_mirrored_value();
          `uvm_info(get_type_name(), $sformatf("gpio out : %h", data), UVM_LOW)
        end
        1: begin // GPIO pd
          m_spi_env.m_regmodel.gpio_pd.write(status, data_w.data);
          m_spi_env.m_regmodel.gpio_pd.mirror(status, UVM_CHECK);
          data = m_spi_env.m_regmodel.gpio_pd.get_mirrored_value();
          `uvm_info(get_type_name(), $sformatf("gpio pd : %h", data), UVM_LOW)
        end
        1: begin // GPIO pu
          m_spi_env.m_regmodel.gpio_pu.write(status, data_w.data);
          m_spi_env.m_regmodel.gpio_pu.mirror(status, UVM_CHECK);
          data = m_spi_env.m_regmodel.gpio_pu.get_mirrored_value();
          `uvm_info(get_type_name(), $sformatf("gpio pu : %h", data), UVM_LOW)
        end
      endcase
    end

    #(100ns);
    phase.drop_objection(this);
  endtask
endclass


