['# @version 0.2.12\n', '"""\n', '@title Curve Factory\n', '@license MIT\n', '@author Curve.Fi\n', '@notice Permissionless pool deployer and registry\n', '"""\n', '\n', 'struct PoolArray:\n', '    base_pool: address\n', '    coins: address[2]\n', '    decimals: uint256\n', '\n', 'struct BasePoolArray:\n', '    implementation: address\n', '    lp_token: address\n', '    coins: address[MAX_COINS]\n', '    decimals: uint256\n', '    n_coins: uint256\n', '\n', '\n', 'interface AddressProvider:\n', '    def admin() -> address: view\n', '    def get_registry() -> address: view\n', '\n', 'interface Registry:\n', '    def get_lp_token(pool: address) -> address: view\n', '    def get_n_coins(pool: address) -> uint256: view\n', '    def get_coins(pool: address) -> address[MAX_COINS]: view\n', '\n', 'interface ERC20:\n', '    def balanceOf(_addr: address) -> uint256: view\n', '    def decimals() -> uint256: view\n', '    def totalSupply() -> uint256: view\n', '    def approve(_spender: address, _amount: uint256): nonpayable\n', '\n', 'interface CurvePool:\n', '    def A() -> uint256: view\n', '    def fee() -> uint256: view\n', '    def admin_fee() -> uint256: view\n', '    def balances(i: uint256) -> uint256: view\n', '    def admin_balances(i: uint256) -> uint256: view\n', '    def get_virtual_price() -> uint256: view\n', '    def initialize(\n', '        _name: String[32],\n', '        _symbol: String[10],\n', '        _coin: address,\n', '        _decimals: uint256,\n', '        _A: uint256,\n', '        _fee: uint256,\n', '        _owner: address,\n', '    ): nonpayable\n', '    def exchange(\n', '        i: int128,\n', '        j: int128,\n', '        dx: uint256,\n', '        min_dy: uint256,\n', '        _receiver: address,\n', '    ) -> uint256: nonpayable\n', '\n', '\n', 'event BasePoolAdded:\n', '    base_pool: address\n', '    implementat: address\n', '\n', 'event MetaPoolDeployed:\n', '    coin: address\n', '    base_pool: address\n', '    A: uint256\n', '    fee: uint256\n', '    deployer: address\n', '\n', '\n', 'MAX_COINS: constant(int128) = 8\n', 'ADDRESS_PROVIDER: constant(address) = 0x0000000022D53366457F9d5E68Ec105046FC4383\n', '\n', 'admin: public(address)\n', 'future_admin: public(address)\n', '\n', 'pool_list: public(address[4294967296])   # master list of pools\n', 'pool_count: public(uint256)              # actual length of pool_list\n', 'pool_data: HashMap[address, PoolArray]\n', '\n', 'base_pool_list: public(address[4294967296])   # master list of pools\n', 'base_pool_count: public(uint256)         # actual length of pool_list\n', 'base_pool_data: HashMap[address, BasePoolArray]\n', '\n', '# mapping of coins -> pools for trading\n', '# a mapping key is generated for each pair of addresses via\n', '# `bitwise_xor(convert(a, uint256), convert(b, uint256))`\n', 'markets: HashMap[uint256, address[4294967296]]\n', 'market_counts: HashMap[uint256, uint256]\n', '\n', '# base pool -> address to transfer admin fees to\n', 'fee_receiver: public(HashMap[address, address])\n', '\n', '@external\n', 'def __init__():\n', '    self.admin = msg.sender\n', '\n', '\n', '@view\n', '@external\n', 'def find_pool_for_coins(_from: address, _to: address, i: uint256 = 0) -> address:\n', '    """\n', '    @notice Find an available pool for exchanging two coins\n', '    @param _from Address of coin to be sent\n', '    @param _to Address of coin to be received\n', '    @param i Index value. When multiple pools are available\n', "            this value is used to return the n'th address.\n", '    @return Pool address\n', '    """\n', '    key: uint256 = bitwise_xor(convert(_from, uint256), convert(_to, uint256))\n', '    return self.markets[key][i]\n', '\n', '\n', '@view\n', '@external\n', 'def get_n_coins(_pool: address) -> (uint256, uint256):\n', '    """\n', '    @notice Get the number of coins in a pool\n', '    @param _pool Pool address\n', '    @return Number of wrapped coins, number of underlying coins\n', '    """\n', '    base_pool: address = self.pool_data[_pool].base_pool\n', '    return 2, self.base_pool_data[base_pool].n_coins + 1\n', '\n', '\n', '@view\n', '@external\n', 'def get_coins(_pool: address) -> address[2]:\n', '    """\n', '    @notice Get the coins within a pool\n', '    @param _pool Pool address\n', '    @return List of coin addresses\n', '    """\n', '    return self.pool_data[_pool].coins\n', '\n', '\n', '@view\n', '@external\n', 'def get_underlying_coins(_pool: address) -> address[MAX_COINS]:\n', '    """\n', '    @notice Get the underlying coins within a pool\n', '    @param _pool Pool address\n', '    @return List of coin addresses\n', '    """\n', '    coins: address[MAX_COINS] = empty(address[MAX_COINS])\n', '    coins[0] = self.pool_data[_pool].coins[0]\n', '    base_pool: address = self.pool_data[_pool].base_pool\n', '    for i in range(1, MAX_COINS):\n', '        coins[i] = self.base_pool_data[base_pool].coins[i - 1]\n', '        if coins[i] == ZERO_ADDRESS:\n', '            break\n', '\n', '    return coins\n', '\n', '\n', '@view\n', '@external\n', 'def get_decimals(_pool: address) -> uint256[2]:\n', '    """\n', '    @notice Get decimal places for each coin within a pool\n', '    @param _pool Pool address\n', '    @return uint256 list of decimals\n', '    """\n', '    decimals: uint256[2] = [0, 18]\n', '    decimals[0] = self.pool_data[_pool].decimals\n', '    return decimals\n', '\n', '\n', '@view\n', '@external\n', 'def get_underlying_decimals(_pool: address) -> uint256[MAX_COINS]:\n', '    """\n', '    @notice Get decimal places for each underlying coin within a pool\n', '    @param _pool Pool address\n', '    @return uint256 list of decimals\n', '    """\n', '    # decimals are tightly packed as a series of uint8 within a little-endian bytes32\n', '    # the packed value is stored as uint256 to simplify unpacking via shift and modulo\n', '    decimals: uint256[MAX_COINS] = empty(uint256[MAX_COINS])\n', '    decimals[0] = self.pool_data[_pool].decimals\n', '    base_pool: address = self.pool_data[_pool].base_pool\n', '    packed_decimals: uint256 = self.base_pool_data[base_pool].decimals\n', '    for i in range(MAX_COINS):\n', '        unpacked: uint256 = shift(packed_decimals, -8 * i) % 256\n', '        if unpacked == 0:\n', '            break\n', '        decimals[i+1] = unpacked\n', '\n', '    return decimals\n', '\n', '\n', '@view\n', '@external\n', 'def get_rates(_pool: address) -> uint256[2]:\n', '    """\n', '    @notice Get rates for coins within a pool\n', '    @param _pool Pool address\n', '    @return Rates for each coin, precision normalized to 10**18\n', '    """\n', '    rates: uint256[2] = [10**18, 0]\n', '    rates[1] = CurvePool(self.pool_data[_pool].base_pool).get_virtual_price()\n', '    return rates\n', '\n', '\n', '@view\n', '@external\n', 'def get_balances(_pool: address) -> uint256[2]:\n', '    """\n', '    @notice Get balances for each coin within a pool\n', '    @dev For pools using lending, these are the wrapped coin balances\n', '    @param _pool Pool address\n', '    @return uint256 list of balances\n', '    """\n', '    return [CurvePool(_pool).balances(0), CurvePool(_pool).balances(1)]\n', '\n', '\n', '@view\n', '@external\n', 'def get_underlying_balances(_pool: address) -> uint256[MAX_COINS]:\n', '    """\n', '    @notice Get balances for each underlying coin within a pool\n', '    @param _pool Pool address\n', '    @return uint256 list of underlying balances\n', '    """\n', '\n', '    underlying_balances: uint256[MAX_COINS] = empty(uint256[MAX_COINS])\n', '    underlying_balances[0] = CurvePool(_pool).balances(0)\n', '\n', '    base_total_supply: uint256 = ERC20(self.pool_data[_pool].coins[1]).totalSupply()\n', '    if base_total_supply > 0:\n', '        underlying_pct: uint256 = CurvePool(_pool).balances(1) * 10**36 / base_total_supply\n', '        base_pool: address = self.pool_data[_pool].base_pool\n', '        n_coins: uint256 = self.base_pool_data[base_pool].n_coins\n', '        for i in range(MAX_COINS):\n', '            if i == n_coins:\n', '                break\n', '            underlying_balances[i + 1] = CurvePool(base_pool).balances(i) * underlying_pct / 10**36\n', '\n', '    return underlying_balances\n', '\n', '\n', '@view\n', '@external\n', 'def get_A(_pool: address) -> uint256:\n', '    """\n', '    @notice Get the amplfication co-efficient for a pool\n', '    @param _pool Pool address\n', '    @return uint256 A\n', '    """\n', '    return CurvePool(_pool).A()\n', '\n', '\n', '@view\n', '@external\n', 'def get_fees(_pool: address) -> (uint256, uint256):\n', '    """\n', '    @notice Get the fees for a pool\n', '    @dev Fees are expressed as integers\n', '    @return Pool fee as uint256 with 1e10 precision\n', '    """\n', '    return CurvePool(_pool).fee(), CurvePool(_pool).admin_fee()\n', '\n', '\n', '@view\n', '@external\n', 'def get_admin_balances(_pool: address) -> uint256[2]:\n', '    """\n', '    @notice Get the current admin balances (uncollected fees) for a pool\n', '    @param _pool Pool address\n', '    @return List of uint256 admin balances\n', '    """\n', '    return [CurvePool(_pool).admin_balances(0), CurvePool(_pool).admin_balances(1)]\n', '\n', '\n', '@view\n', '@external\n', 'def get_coin_indices(\n', '    _pool: address,\n', '    _from: address,\n', '    _to: address\n', ') -> (int128, int128, bool):\n', '    """\n', '    @notice Convert coin addresses to indices for use with pool methods\n', '    @param _from Coin address to be used as `i` within a pool\n', '    @param _to Coin address to be used as `j` within a pool\n', '    @return int128 `i`, int128 `j`, boolean indicating if `i` and `j` are underlying coins\n', '    """\n', '    coin: address = self.pool_data[_pool].coins[0]\n', '    if coin in [_from, _to]:\n', '        base_lp_token: address = self.pool_data[_pool].coins[1]\n', '        if base_lp_token in [_from, _to]:\n', '            # True and False convert to 1 and 0 - a bit of voodoo that\n', '            # works because we only ever have 2 non-underlying coins\n', '            return convert(_to == coin, int128), convert(_from == coin, int128), False\n', '\n', '    base_pool: address = self.pool_data[_pool].base_pool\n', '    found_market: bool = False\n', '    i: int128 = 0\n', '    j: int128 = 0\n', '    for x in range(MAX_COINS):\n', '        if x != 0:\n', '            coin = self.base_pool_data[base_pool].coins[x-1]\n', '        if coin == ZERO_ADDRESS:\n', '            raise "No available market"\n', '        if coin == _from:\n', '            i = x\n', '        elif coin == _to:\n', '            j = x\n', '        else:\n', '            continue\n', '        if found_market:\n', '            # the second time we find a match, break out of the loop\n', '            break\n', '        # the first time we find a match, set `found_market` to True\n', '        found_market = True\n', '\n', '    return i, j, True\n', '\n', '\n', '@external\n', 'def add_base_pool(\n', '    _base_pool: address,\n', '    _metapool_implementation: address,\n', '    _fee_receiver: address,\n', '):\n', '    """\n', '    @notice Add a pool to the registry\n', '    @dev Only callable by admin\n', '    @param _base_pool Pool address to add\n', '    @param _metapool_implementation Implementation address to use when deploying metapools\n', '    @param _fee_receiver Admin fee receiver address for metapools using this base pool\n', '    """\n', '    assert msg.sender == self.admin  # dev: admin-only function\n', '    assert self.base_pool_data[_base_pool].coins[0] == ZERO_ADDRESS  # dev: pool exists\n', '\n', '    registry: address = AddressProvider(ADDRESS_PROVIDER).get_registry()\n', '    n_coins: uint256 = Registry(registry).get_n_coins(_base_pool)\n', '\n', '    # add pool to pool_list\n', '    length: uint256 = self.base_pool_count\n', '    self.base_pool_list[length] = _base_pool\n', '    self.base_pool_count = length + 1\n', '    self.base_pool_data[_base_pool].implementation = _metapool_implementation\n', '    self.base_pool_data[_base_pool].lp_token = Registry(registry).get_lp_token(_base_pool)\n', '    self.base_pool_data[_base_pool].n_coins = n_coins\n', '\n', '    decimals: uint256 = 0\n', '    coins: address[MAX_COINS] = Registry(registry).get_coins(_base_pool)\n', '    for i in range(MAX_COINS):\n', '        if i == n_coins:\n', '            break\n', '        coin: address = coins[i]\n', '        self.base_pool_data[_base_pool].coins[i] = coin\n', '        decimals += shift(ERC20(coin).decimals(), convert(i*8, int128))\n', '\n', '    self.base_pool_data[_base_pool].decimals = decimals\n', '    self.fee_receiver[_base_pool] = _fee_receiver\n', '\n', '    log BasePoolAdded(_base_pool, _metapool_implementation)\n', '\n', '\n', '@external\n', 'def deploy_metapool(\n', '    _base_pool: address,\n', '    _name: String[32],\n', '    _symbol: String[10],\n', '    _coin: address,\n', '    _A: uint256,\n', '    _fee: uint256,\n', ') -> address:\n', '    """\n', '    @notice Deploy a new metapool\n', '    @param _base_pool Address of the base pool to use\n', '                      within the metapool\n', '    @param _name Name of the new metapool\n', '    @param _symbol Symbol for the new metapool - will be\n', '                   concatenated with the base pool symbol\n', '    @param _coin Address of the coin being used in the metapool\n', '    @param _A Amplification co-efficient - a higher value here means\n', "              less tolerance for imbalance within the pool's assets.\n", '              Suggested values include:\n', '               * Uncollateralized algorithmic stablecoins: 5-10\n', '               * Non-redeemable, collateralized assets: 100\n', '               * Redeemable assets: 200-400\n', '    @param _fee Trade fee, given as an integer with 1e10 precision. The\n', '                minimum fee is 0.04% (4000000), the maximum is 1% (100000000).\n', '                50% of the fee is distributed to veCRV holders.\n', '    @return Address of the deployed pool\n', '    """\n', '    implementation: address = self.base_pool_data[_base_pool].implementation\n', '    assert implementation != ZERO_ADDRESS\n', '\n', '    decimals: uint256 = ERC20(_coin).decimals()\n', '    pool: address = create_forwarder_to(implementation)\n', '    CurvePool(pool).initialize(_name, _symbol, _coin, decimals, _A, _fee, self.admin)\n', '    ERC20(_coin).approve(pool, MAX_UINT256)\n', '\n', '    # add pool to pool_list\n', '    length: uint256 = self.pool_count\n', '    self.pool_list[length] = pool\n', '    self.pool_count = length + 1\n', '\n', '    base_lp_token: address = self.base_pool_data[_base_pool].lp_token\n', '\n', '    self.pool_data[pool].decimals = decimals\n', '    self.pool_data[pool].base_pool = _base_pool\n', '    self.pool_data[pool].coins = [_coin, self.base_pool_data[_base_pool].lp_token]\n', '\n', '    is_finished: bool = False\n', '    for i in range(MAX_COINS):\n', '        swappable_coin: address = self.base_pool_data[_base_pool].coins[i]\n', '        if swappable_coin == ZERO_ADDRESS:\n', '            is_finished = True\n', '            swappable_coin = base_lp_token\n', '\n', '        key: uint256 = bitwise_xor(convert(_coin, uint256), convert(swappable_coin, uint256))\n', '        length = self.market_counts[key]\n', '        self.markets[key][length] = pool\n', '        self.market_counts[key] = length + 1\n', '        if is_finished:\n', '            break\n', '\n', '    log MetaPoolDeployed(_coin, _base_pool, _A, _fee, msg.sender)\n', '    return pool\n', '\n', '\n', '@external\n', 'def commit_transfer_ownership(addr: address):\n', '    """\n', '    @notice Transfer ownership of this contract to `addr`\n', '    @param addr Address of the new owner\n', '    """\n', '    assert msg.sender == self.admin  # dev: admin only\n', '\n', '    self.future_admin = addr\n', '\n', '\n', '@external\n', 'def accept_transfer_ownership():\n', '    """\n', '    @notice Accept a pending ownership transfer\n', '    @dev Only callable by the new owner\n', '    """\n', '    _admin: address = self.future_admin\n', '    assert msg.sender == _admin  # dev: future admin only\n', '\n', '    self.admin = _admin\n', '    self.future_admin = ZERO_ADDRESS\n', '\n', '\n', '@external\n', 'def set_fee_receiver(_base_pool: address, _fee_receiver: address):\n', '    assert msg.sender == self.admin  # dev: admin only\n', '    self.fee_receiver[_base_pool] = _fee_receiver\n', '\n', '\n', '@external\n', 'def convert_fees() -> bool:\n', '    coin: address = self.pool_data[msg.sender].coins[0]\n', '    assert coin != ZERO_ADDRESS  # dev: unknown pool\n', '\n', '    amount: uint256 = ERC20(coin).balanceOf(self)\n', '    receiver: address = self.fee_receiver[self.pool_data[msg.sender].base_pool]\n', '\n', '    CurvePool(msg.sender).exchange(0, 1, amount, 0, receiver)\n', '    return True']