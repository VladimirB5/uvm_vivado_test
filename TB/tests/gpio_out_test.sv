// gpio_in.sv
class gpio_out_test extends base_test;
  `uvm_component_utils(gpio_out_test)

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
    repeat(100) begin
      #(100ns);
      m_spi_seq = spi_sequence_gpio_out::type_id::create("spi_sequence_gpio_out");
      m_spi_seq.start(m_spi_env.m_agent.m_sequencer);
    end

    #(100ns);
    phase.drop_objection(this);
  endtask
endclass

