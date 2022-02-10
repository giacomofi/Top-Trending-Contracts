['# @version 0.2.5\n', '"""\n', '@title Curve StableSwap Proxy\n', '@author Curve Finance\n', '@license MIT\n', '"""\n', '\n', 'from vyper.interfaces import ERC20\n', '\n', 'interface Burner:\n', '    def burn() -> bool: nonpayable\n', '    def burn_eth() -> bool: payable\n', '    def burn_coin(_coin: address)-> bool: nonpayable\n', '\n', 'interface Curve:\n', '    def withdraw_admin_fees(): nonpayable\n', '    def kill_me(): nonpayable\n', '    def unkill_me(): nonpayable\n', '    def commit_transfer_ownership(new_owner: address): nonpayable\n', '    def apply_transfer_ownership(): nonpayable\n', '    def revert_transfer_ownership(): nonpayable\n', '    def commit_new_parameters(amplification: uint256, new_fee: uint256, new_admin_fee: uint256): nonpayable\n', '    def apply_new_parameters(): nonpayable\n', '    def revert_new_parameters(): nonpayable\n', '    def commit_new_fee(new_fee: uint256, new_admin_fee: uint256): nonpayable\n', '    def apply_new_fee(): nonpayable\n', '    def ramp_A(_future_A: uint256, _future_time: uint256): nonpayable\n', '    def stop_ramp_A(): nonpayable\n', '    def set_aave_referral(referral_code: uint256): nonpayable\n', '    def donate_admin_fees(): nonpayable\n', '\n', '\n', 'interface Registry:\n', '    def get_pool_info(_pool: address) -> PoolInfo: view\n', '\n', '\n', 'MAX_COINS: constant(int128) = 8\n', '\n', 'struct PoolInfo:\n', '    balances: uint256[MAX_COINS]\n', '    underlying_balances: uint256[MAX_COINS]\n', '    decimals: uint256[MAX_COINS]\n', '    underlying_decimals: uint256[MAX_COINS]\n', '    lp_token: address\n', '    A: uint256\n', '    fee: uint256\n', '\n', 'event CommitAdmins:\n', '    ownership_admin: address\n', '    parameter_admin: address\n', '    emergency_admin: address\n', '\n', 'event ApplyAdmins:\n', '    ownership_admin: address\n', '    parameter_admin: address\n', '    emergency_admin: address\n', '\n', 'event AddBurner:\n', '    burner: address\n', '\n', '\n', 'ownership_admin: public(address)\n', 'parameter_admin: public(address)\n', 'emergency_admin: public(address)\n', '\n', 'future_ownership_admin: public(address)\n', 'future_parameter_admin: public(address)\n', 'future_emergency_admin: public(address)\n', '\n', 'min_asymmetries: public(HashMap[address, uint256])\n', '\n', 'burners: public(HashMap[address, address])\n', '\n', 'registry: Registry\n', '\n', '\n', '@external\n', 'def __init__(_registry: address, _ownership_admin: address, _parameter_admin: address, _emergency_admin: address):\n', '    self.ownership_admin = _ownership_admin\n', '    self.parameter_admin = _parameter_admin\n', '    self.emergency_admin = _emergency_admin\n', '    self.registry = Registry(_registry)\n', '\n', '\n', '@external\n', 'def commit_set_admins(_o_admin: address, _p_admin: address, _e_admin: address):\n', '    """\n', '    @notice Set ownership admin to `_o_admin`, parameter admin to `_p_admin` and emergency admin to `_e_admin`\n', '    @param _o_admin Ownership admin\n', '    @param _p_admin Parameter admin\n', '    @param _e_admin Emergency admin\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '\n', '    self.future_ownership_admin = _o_admin\n', '    self.future_parameter_admin = _p_admin\n', '    self.future_emergency_admin = _e_admin\n', '\n', '    log CommitAdmins(_o_admin, _p_admin, _e_admin)\n', '\n', '\n', '@external\n', 'def apply_set_admins():\n', '    """\n', '    @notice Apply the effects of `commit_set_admins`\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '\n', '    _o_admin: address = self.future_ownership_admin\n', '    _p_admin: address = self.future_parameter_admin\n', '    _e_admin: address = self.future_emergency_admin\n', '    self.ownership_admin = _o_admin\n', '    self.parameter_admin = _p_admin\n', '    self.emergency_admin = _e_admin\n', '\n', '    log ApplyAdmins(_o_admin, _p_admin, _e_admin)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def set_burner(_token: address, _burner: address):\n', '    """\n', '    @notice Set burner of `_token` to `_burner` address\n', '    @param _token Token address\n', '    @param _burner Burner contract address\n', '    """\n', '    assert msg.sender == self.emergency_admin, "Access denied"\n', '\n', '    _old_burner: address = self.burners[_token]\n', '\n', '    if _token != ZERO_ADDRESS:\n', '        if _old_burner != ZERO_ADDRESS:\n', '            ERC20(_token).approve(_old_burner, 0)\n', '        if _burner != ZERO_ADDRESS:\n', '            ERC20(_token).approve(_burner, MAX_UINT256)\n', '\n', '    self.burners[_token] = _burner\n', '\n', '    log AddBurner(_burner)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def withdraw_admin_fees(_pool: address):\n', '    """\n', '    @notice Withdraw admin fees from `_pool`\n', '    @param _pool Pool address to withdraw admin fees from\n', '    """\n', '    Curve(_pool).withdraw_admin_fees()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def burn(_burner: address):\n', '    """\n', '    @notice Burn CRV tokens using `_burner` contract\n', '    @param _burner Burner contract\n', '    """\n', '    Burner(_burner).burn()  # dev: should implement burn()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def burn_coin(_coin: address):\n', '    """\n', '    @notice Burn CRV tokens and buy `_coin`\n', '    @param _coin Coin address\n', '    """\n', '    Burner(self.burners[_coin]).burn_coin(_coin)  # dev: should implement burn_coin()\n', '\n', '\n', '@external\n', '@payable\n', "@nonreentrant('lock')\n", 'def burn_eth():\n', '    """\n', '    @notice Burn the full ETH balance of this contract\n', '    """\n', '    Burner(self.burners[ZERO_ADDRESS]).burn_eth(value=self.balance)  # dev: should implement burn_eth()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def kill_me(_pool: address):\n', '    """\n', '    @notice Pause the pool `_pool` - only remove_liquidity will be callable\n', '    @param _pool Pool address to pause\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '    Curve(_pool).kill_me()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def unkill_me(_pool: address):\n', '    """\n', '    @notice Unpause the pool `_pool`, re-enabling all functionality\n', '    @param _pool Pool address to unpause\n', '    """\n', '    assert msg.sender == self.emergency_admin or msg.sender == self.ownership_admin, "Access denied"\n', '    Curve(_pool).unkill_me()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def commit_transfer_ownership(_pool: address, new_owner: address):\n', '    """\n', '    @notice Transfer ownership for `_pool` pool to `new_owner` address\n', '    @param _pool Pool which ownership is to be transferred\n', '    @param new_owner New pool owner address\n', '    """\n', '    assert msg.sender == self.emergency_admin, "Access denied"\n', '    Curve(_pool).commit_transfer_ownership(new_owner)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def apply_transfer_ownership(_pool: address):\n', '    """\n', '    @notice Apply transferring ownership of `_pool`\n', '    @param _pool Pool address\n', '    """\n', '    Curve(_pool).apply_transfer_ownership()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def revert_transfer_ownership(_pool: address):\n', '    """\n', '    @notice Revert commited transferring ownership for `_pool`\n', '    @param _pool Pool address\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '    Curve(_pool).revert_transfer_ownership()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def commit_new_parameters(_pool: address,\n', '                          amplification: uint256,\n', '                          new_fee: uint256,\n', '                          new_admin_fee: uint256,\n', '                          min_asymmetry: uint256):\n', '    """\n', '    @notice Commit new parameters for `_pool`, A: `amplification`, fee: `new_fee` and admin fee: `new_admin_fee`\n', '    @param _pool Pool address\n', '    @param amplification Amplification coefficient\n', '    @param new_fee New fee\n', '    @param new_admin_fee New admin fee\n', '    @param min_asymmetry Minimal asymmetry factor allowed.\n', '            Asymmetry factor is:\n', '            Prod(balances) / (Sum(balances) / N) ** N\n', '    """\n', '    assert msg.sender == self.parameter_admin, "Access denied"\n', '    self.min_asymmetries[_pool] = min_asymmetry\n', '    Curve(_pool).commit_new_parameters(amplification, new_fee, new_admin_fee)  # dev: if implemented by the pool\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def apply_new_parameters(_pool: address):\n', '    """\n', '    @notice Apply new parameters for `_pool` pool\n', '    @param _pool Pool address\n', '    """\n', '    min_asymmetry: uint256 = self.min_asymmetries[_pool]\n', '\n', '    if min_asymmetry > 0:\n', '        pool_info: PoolInfo = self.registry.get_pool_info(_pool)\n', '        balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])\n', '        # asymmetry = prod(x_i) / (sum(x_i) / N) ** N =\n', '        # = prod( (N * x_i) / sum(x_j) )\n', '        S: uint256 = 0\n', '        N: uint256 = 0\n', '        for i in range(MAX_COINS):\n', '            x: uint256 = pool_info.underlying_balances[i]\n', '            if x == 0:\n', '                N = convert(i, uint256)\n', '                break\n', '            x *= 10 ** (18 - pool_info.decimals[i])\n', '            balances[i] = x\n', '            S += x\n', '\n', '        asymmetry: uint256 = N * 10 ** 18\n', '        for i in range(MAX_COINS):\n', '            x: uint256 = balances[i]\n', '            if x == 0:\n', '                break\n', '            asymmetry = asymmetry * x / S\n', '\n', '        assert asymmetry >= min_asymmetry, "Unsafe to apply"\n', '\n', '    Curve(_pool).apply_new_parameters()  # dev: if implemented by the pool\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def revert_new_parameters(_pool: address):\n', '    """\n', '    @notice Revert comitted new parameters for `_pool` pool\n', '    @param _pool Pool address\n', '    """\n', '    assert msg.sender == self.parameter_admin, "Access denied"\n', '    Curve(_pool).revert_new_parameters()  # dev: if implemented by the pool\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def commit_new_fee(_pool: address, new_fee: uint256, new_admin_fee: uint256):\n', '    """\n', '    @notice Commit new fees for `_pool` pool, fee: `new_fee` and admin fee: `new_admin_fee`\n', '    @param _pool Pool address\n', '    @param new_fee New fee\n', '    @param new_admin_fee New admin fee\n', '    """\n', '    assert msg.sender == self.parameter_admin, "Access denied"\n', '    Curve(_pool).commit_new_fee(new_fee, new_admin_fee)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def apply_new_fee(_pool: address):\n', '    """\n', '    @notice Apply new fees for `_pool` pool\n', '    @param _pool Pool address\n', '    """\n', '    Curve(_pool).apply_new_fee()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def ramp_A(_pool: address, _future_A: uint256, _future_time: uint256):\n', '    """\n', '    @notice Start gradually increasing A of `_pool` reaching `_future_A` at `_future_time` time\n', '    @param _pool Pool address\n', '    @param _future_A Future A\n', '    @param _future_time Future time\n', '    """\n', '    assert msg.sender == self.parameter_admin, "Access denied"\n', '    Curve(_pool).ramp_A(_future_A, _future_time)\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def stop_ramp_A(_pool: address):\n', '    """\n', '    @notice Stop gradually increasing A of `_pool`\n', '    @param _pool Pool address\n', '    """\n', '    assert msg.sender == self.parameter_admin, "Access denied"\n', '    Curve(_pool).stop_ramp_A()\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def set_aave_referral(_pool: address, referral_code: uint256):\n', '    """\n', '    @notice Set Aave referral for undelying tokens of `_pool` to `referral_code`\n', '    @param _pool Pool address\n', '    @param referral_code Aave referral code\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '    Curve(_pool).set_aave_referral(referral_code)  # dev: if implemented by the pool\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def donate_admin_fees(_pool: address):\n', '    """\n', '    @notice Donate admin fees of `_pool` pool\n', '    @param _pool Pool address\n', '    """\n', '    assert msg.sender == self.ownership_admin, "Access denied"\n', '    Curve(_pool).donate_admin_fees()  # dev: if implemented by the pool']