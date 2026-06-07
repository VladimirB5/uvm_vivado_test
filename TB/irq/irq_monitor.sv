class irq_monitor extends uvm_monitor;
  `uvm_component_utils(irq_monitor)

  virtual irq_if irq_vif;

  uvm_analysis_port #(irq_item) irq_ap;
  uvm_event irq_asserted_ev;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    irq_ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual irq_if)::get(this, "", "irq_vif", irq_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
    irq_asserted_ev = uvm_event_pool::get_global("irq_asserted");
  endfunction

  task run_phase(uvm_phase phase);
    irq_item tr;

    forever begin
      wait (irq_vif.interrupt === 1'b1);

      tr = new();
      tr.asserted = 1'b1;
      tr.deaserted = 1'b0;
      tr.time_val  = $time;

      irq_asserted_ev.trigger();
      irq_ap.write(tr);

      wait (irq_vif.interrupt === 1'b0);

      tr = new();
      tr.asserted = 1'b0;
      tr.deaserted = 1'b1;
      tr.time_val  = $time;

      irq_ap.write(tr);
    end
  endtask
endclass
