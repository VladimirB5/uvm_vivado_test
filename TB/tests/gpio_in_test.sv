// gpio_in.sv
class gpio_in_test extends base_test;
  `uvm_component_utils(gpio_in_test)

  uvm_status_e status;
  uvm_reg_data_t value;
  logic [7:0] data;


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
    gpio_sequence m_gpio_seq;
    phase.raise_objection(this);

    m_clk_rst_seq = clk_rst_sequence::type_id::create("clk_rst_seq");
    m_clk_rst_seq.start(m_clk_rst_env.agent.sequencer);

    // try before input enable is set
    repeat(3) begin
      #(100ns);
      m_gpio_seq = gpio_sequence::type_id::create("gpio_seq");
      m_gpio_seq.start(m_gpio_env.m_agent.m_sequencer);
      #(5us);

      m_spi_env.m_regmodel.gpio_in.mirror(status, UVM_CHECK);
      data = m_spi_env.m_regmodel.gpio_in.get_mirrored_value();
      `uvm_info(get_type_name(), $sformatf("gpio in : %h", data), UVM_LOW)

    end

    // input enable
    #(100ns);
    m_spi_env.m_regmodel.input_en.write(status, 8'hff);

    repeat(10) begin
      #(100ns);
      m_gpio_seq = gpio_sequence::type_id::create("gpio_seq");
      m_gpio_seq.start(m_gpio_env.m_agent.m_sequencer);
      #(5us);

      m_spi_env.m_regmodel.gpio_in.mirror(status, UVM_CHECK);
      data = m_spi_env.m_regmodel.gpio_in.get_mirrored_value();
      `uvm_info(get_type_name(), $sformatf("gpio in : %h", data), UVM_LOW)

    end

    #(100ns);
    phase.drop_objection(this);
  endtask
endclass
