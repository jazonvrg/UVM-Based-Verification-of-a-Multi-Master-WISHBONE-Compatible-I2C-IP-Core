class i2c_agent extends uvm_agent;
  `uvm_component_utils(i2c_agent)
	
  virtual i2c_if vif;
  i2c_monitor mnt;

  function new(string name = "i2c_agent", uvm_component parent);
    super.new(name, parent);
    is_active = UVM_PASSIVE;
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
		`uvm_fatal(get_type_name(), "Failed to get i2c_if from uvm_config_db")
		mnt = i2c_monitor::type_id::create("mnt", this);
	  uvm_config_db#(virtual i2c_if)::set(this, "mnt", "vif", vif);
  endfunction: build_phase
	
endclass: i2c_agent
