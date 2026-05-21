// basic_test.sv
class basic_test extends base_test;
  `uvm_component_utils(basic_test)
    
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
    spi_sequence m_spi_seq;
    gpio_sequence m_gpio_seq;
    phase.raise_objection(this);

    m_clk_rst_seq = clk_rst_sequence::type_id::create("clk_rst_seq");
    //seq.set_clock = 1'b1;
    //seq.enable_clock = 1'b0;
    m_clk_rst_seq.start(m_clk_rst_env.agent.sequencer);
    #(100ns);
    m_gpio_seq = gpio_sequence::type_id::create("gpio_seq");
    m_gpio_seq.start(m_gpio_env.m_agent.m_sequencer);
    
    #(100ns);
    m_spi_seq = spi_sequence::type_id::create("spi_seq");
    m_spi_seq.start(m_spi_env.m_agent.m_sequencer);

    #(100ns);
    m_gpio_seq = gpio_sequence::type_id::create("gpio_seq");
    m_gpio_seq.start(m_gpio_env.m_agent.m_sequencer);

    #(100ns);
    m_spi_env.m_regmodel.gpio_out.write(status, 8'h01);
    #(100ns);
    m_spi_env.m_regmodel.gpio_out.mirror(status, UVM_CHECK);
    data = m_spi_env.m_regmodel.gpio_out.get_mirrored_value();
    `uvm_info(get_type_name(), $sformatf("gpio out : %h", data), UVM_LOW)

    #(100ns);
    phase.drop_objection(this);
  endtask
endclass
