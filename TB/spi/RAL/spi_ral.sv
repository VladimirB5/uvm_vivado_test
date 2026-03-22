 
class spi_reg8 extends uvm_reg;
    `uvm_object_utils(spi_reg8)

    uvm_reg_field bits;

    function new(string name = "spi_reg8");
      super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    virtual function void build(string access = "RW",
                                bit volatile_f = 0,
                                uvm_reg_data_t reset_val = 8'h0);
      bits = uvm_reg_field::type_id::create("bits");
      bits.configure(this,
                     8,         // size
                     0,          // lsb_pos
                     access,     // access
                     volatile_f, // volatile
                     reset_val,  // reset
                     1,          // has_reset
                     1,          // is_rand
                     0);         // individually_accessible
    endfunction
  endclass


  // ------------------------------------------------------------
  // Register block
  // ------------------------------------------------------------
  class spi_reg_block extends uvm_reg_block;
    `uvm_object_utils(spi_reg_block)

    rand spi_reg8       gpio_out;

    uvm_reg_map spi_reg_map;

    function new(string name = "spi_reg_block");
      super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();

      // Create default map:
      // base_addr = 0
      // n_bytes = 4 (32-bit bus)
      // endian = little
      spi_reg_map = create_map("spi_reg_map", 'h0, 4, UVM_LITTLE_ENDIAN);

      gpio_out = spi_reg8::type_id::create("gpio_out");
      gpio_out.configure(this, null, "");
      gpio_out.build("RW", 0, 8'h00);
      spi_reg_map.add_reg(gpio_out, 'h0, "RW");

      lock_model();
    endfunction
  endclass

  class spi_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils(spi_reg_adapter)

  function new(string name = "spi_reg_adapter");
    super.new(name);
    provides_responses = 0;
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    spi_seq_item tr = spi_seq_item::type_id::create("tr");

    tr.address  = rw.addr;
    tr.write = (rw.kind == UVM_WRITE);
    tr.value = rw.data;

    return tr;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    spi_seq_item tr;
    if (!$cast(tr, bus_item)) begin
      `uvm_fatal("ADAPTER", "bus_item is not my_bus_item")
    end
    `uvm_info(get_type_name(), $sformatf("bus2reg A %h", tr.address), UVM_HIGH)
    `uvm_info(get_type_name(), $sformatf("bus2reg %h", tr.value), UVM_HIGH)
    rw.addr   = tr.address;
    rw.kind   = tr.write ? UVM_WRITE : UVM_READ;
    rw.data   = tr.value;
    rw.status = UVM_IS_OK;
    rw.byte_en = 1'b1;
  endfunction
endclass
