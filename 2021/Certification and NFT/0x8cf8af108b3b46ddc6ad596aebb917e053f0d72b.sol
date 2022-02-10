['# @version 0.2.8\n', '"""\n', '@title Curve StableSwap Owner Proxy\n', '@author Curve Finance\n', '@license MIT\n', "@notice Allows DAO ownership of `Factory` and it's deployed pools\n", '"""\n', '\n', 'interface Curve:\n', '    def ramp_A(_future_A: uint256, _future_time: uint256): nonpayable\n', '    def stop_ramp_A(): nonpayable\n', '\n', 'interface Factory:\n', '    def add_base_pool(\n', '        _base_pool: address,\n', '        _metapool_implementation: address,\n', '        _fee_receiver: address,\n', '    ): nonpayable\n', '    def set_fee_receiver(_base_pool: address, _fee_receiver: address): nonpayable\n', '    def commit_transfer_ownership(addr: address): nonpayable\n', '    def accept_transfer_ownership(): nonpayable\n', '\n', '\n', 'event CommitAdmins:\n', '    ownership_admin: address\n', '    parameter_admin: address\n', '    emergency_admin: address\n', '\n', 'event ApplyAdmins:\n', '    ownership_admin: address\n', '    parameter_admin: address\n', '    emergency_admin: address\n', '\n', 'ownership_admin: public(address)\n', 'parameter_admin: public(address)\n', 'emergency_admin: public(address)\n', '\n', 'future_ownership_admin: public(address)\n', 'future_parameter_admin: public(address)\n', 'future_emergency_admin: public(address)\n', '\n', '\n', '@external\n', 'def __init__(\n', '    _ownership_admin: address,\n', '    _parameter_admin: address,\n', '    _emergency_admin: address\n', '):\n', '    self.ownership_admin = _ownership_admin\n', '    self.parameter_admin = _parameter_admin\n', '    self.emergency_admin = _emergency_admin\n', '\n', '\n', '@external\n', 'def commit_set_admins(_o_admin: address, _p_admin: address, _e_admin: address):\n', '    """\n', '    @notice Set ownership admin to `_o_admin`, parameter admin to `_p_admin` and emergency admin to `_e_admin`\n', '    @param _o_admin Ownership admin\n', '    @param _p_admin Parameter admin\n', '    @param _e_admin Emergency admin\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '\n', '    self.future_ownership_admin = _o_admin\n', '    self.future_parameter_admin = _p_admin\n', '    self.future_emergency_admin = _e_admin\n', '\n', '    log CommitAdmins(_o_admin, _p_admin, _e_admin)\n', '\n', '\n', '@external\n', 'def apply_set_admins():\n', '    """\n', '    @notice Apply the effects of `commit_set_admins`\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '\n', '    _o_admin: address = self.future_ownership_admin\n', '    _p_admin: address = self.future_parameter_admin\n', '    _e_admin: address = self.future_emergency_admin\n', '    self.ownership_admin = _o_admin\n', '    self.parameter_admin = _p_admin\n', '    self.emergency_admin = _e_admin\n', '\n', '    log ApplyAdmins(_o_admin, _p_admin, _e_admin)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def ramp_A(_pool: address, _future_A: uint256, _future_time: uint256):\n', '    """\n', '    @notice Start gradually increasing A of `_pool` reaching `_future_A` at `_future_time` time\n', '    @param _pool Pool address\n', '    @param _future_A Future A\n', '    @param _future_time Future time\n', '    """\n', '    assert msg.sender == self.parameter_admin, "Access denied"\n', '    Curve(_pool).ramp_A(_future_A, _future_time)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def stop_ramp_A(_pool: address):\n', '    """\n', '    @notice Stop gradually increasing A of `_pool`\n', '    @param _pool Pool address\n', '    """\n', '    assert msg.sender in [self.parameter_admin, self.emergency_admin], "Access denied"\n', '    Curve(_pool).stop_ramp_A()\n', '\n', '\n', '@external\n', 'def add_base_pool(\n', '    _target: address,\n', '    _base_pool: address,\n', '    _metapool_implementation: address,\n', '    _fee_receiver: address\n', '):\n', '    assert msg.sender == self.parameter_admin\n', '\n', '    Factory(_target).add_base_pool(_base_pool, _metapool_implementation, _fee_receiver)\n', '\n', '\n', '@external\n', 'def set_fee_receiver(_target: address, _base_pool: address, _fee_receiver: address):\n', '    Factory(_target).set_fee_receiver(_base_pool, _fee_receiver)\n', '\n', '\n', '@external\n', 'def commit_transfer_ownership(_target: address, _new_admin: address):\n', '    """\n', '    @notice Transfer ownership of `_target` to `_new_admin`\n', '    @param _target `Factory` deployment address\n', '    @param _new_admin New admin address\n', '    """\n', '    assert msg.sender == self.parameter_admin  # dev: admin only\n', '\n', '    Factory(_target).commit_transfer_ownership(_new_admin)\n', '\n', '\n', '@external\n', 'def accept_transfer_ownership(_target: address):\n', '    """\n', '    @notice Accept a pending ownership transfer\n', '    @param _target `Factory` deployment address\n', '    """\n', '    Factory(_target).accept_transfer_ownership()']