class irq_item extends uvm_object;
  // Data fields
  bit asserted;
  bit deaserted;
  time time_val;

  time timestamp_tolerance = 2us;

  `uvm_object_utils_begin(irq_item)
    `uvm_field_int(asserted, UVM_DEFAULT)
    `uvm_field_int(deaserted, UVM_DEFAULT)
    `uvm_field_int(time_val, UVM_NOCOMPARE)
  `uvm_object_utils_end

  function new(string name = "irq_item");
    super.new(name);
  endfunction

  virtual function string convert2string();

    return $sformatf(
      "asserted=%b deaserted=%b time_val=%t",
      asserted, deaserted, time_val
    );
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    irq_item m_irq_item;

    if (!$cast(m_irq_item, rhs))
      return 0;

    if (m_irq_item.asserted != asserted)
      return 0;

    if (m_irq_item.deaserted != deaserted)
      return 0;

    if (m_irq_item.time_val > time_val) begin
      if ((m_irq_item.time_val - time_val) > timestamp_tolerance)
        return 0;
    end else begin
      if ((time_val - m_irq_item.time_val) > timestamp_tolerance)
        return 0;
    end

    return 1;
  endfunction
endclass
