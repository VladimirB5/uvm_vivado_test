class irq_item extends uvm_object;
  // Data fields
  bit asserted;
  bit deaserted;
  time time_val;

  `uvm_object_utils_begin(irq_item)
    `uvm_field_int(asserted, UVM_DEFAULT)
    `uvm_field_int(deaserted, UVM_DEFAULT)
    `uvm_field_int(time_val, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "irq_item");
    super.new(name);
  endfunction

  // Optional: implement copy, compare, or do_print methods


  virtual function string convert2string();

    return $sformatf(
      "asserted=%b deaserted=%b time_val=%t",
      asserted, deaserted, time_val
    );

  endfunction
endclass
