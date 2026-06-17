// base_test.sv
class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  clk_rst_env m_clk_rst_env;
  spi_env m_spi_env;
  gpio_env m_gpio_env;
  irq_monitor m_irq_mon;

  // scoreaboard
  spi_gpio_scoreboard m_scb;
  irq_scoreboard m_irq_scb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_clk_rst_env = clk_rst_env::type_id::create("clk_rst_env", this);
    m_spi_env = spi_env::type_id::create("spi_env", this);
    m_gpio_env = gpio_env::type_id::create("gpio_env", this);
    m_irq_mon = irq_monitor::type_id::create("irq_mon", this);
    m_scb = spi_gpio_scoreboard::type_id::create("m_scb", this);
    m_irq_scb = irq_scoreboard::type_id::create("m_irq_scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_gpio_env.m_agent.m_monitor.ap.connect(m_scb.gpio_item_collected_export);
    m_gpio_env.m_agent.m_monitor.ap.connect(m_spi_env.m_gpio2reg.gpio_item_collected_export);
    m_spi_env.m_agent.m_monitor.spi_ap.connect(m_scb.spi_item_collected_export);
    m_irq_mon.irq_ap.connect(m_irq_scb.irq_item_collected_export);
    m_spi_env.m_gpio2reg.irq_ap.connect(m_irq_scb.pred_item_collected_export);
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);


    #(100ns);
    phase.drop_objection(this);
  endtask
endclass
