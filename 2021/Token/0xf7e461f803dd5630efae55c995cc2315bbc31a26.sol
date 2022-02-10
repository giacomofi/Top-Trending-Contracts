['# @version 0.2.12\n', '"""\n', '@title StableSwap\n', '@author Curve.Fi\n', '@license Copyright (c) Curve.Fi, 2021 - all rights reserved\n', '@notice 3pool metapool gauge implementation contract\n', '"""\n', '\n', 'interface LiquidityGauge:\n', '    def lp_token() -> address: view\n', '    def minter() -> address: view\n', '    def crv_token() -> address: view\n', '    def deposit(_value: uint256): nonpayable\n', '    def withdraw(_value: uint256): nonpayable\n', '    def claimable_tokens(addr: address) -> uint256: nonpayable\n', '\n', 'interface Minter:\n', '    def mint(gauge_addr: address): nonpayable\n', '\n', 'interface ERC20:\n', '    def transfer(_receiver: address, _amount: uint256): nonpayable\n', '    def transferFrom(_sender: address, _receiver: address, _amount: uint256): nonpayable\n', '    def approve(_spender: address, _amount: uint256): nonpayable\n', '    def balanceOf(_owner: address) -> uint256: view\n', '\n', 'interface Curve:\n', '    def coins(i: uint256) -> address: view\n', '    def get_virtual_price() -> uint256: view\n', '    def calc_token_amount(amounts: uint256[BASE_N_COINS], deposit: bool) -> uint256: view\n', '    def calc_withdraw_one_coin(_token_amount: uint256, i: int128) -> uint256: view\n', '    def fee() -> uint256: view\n', '    def get_dy(i: int128, j: int128, dx: uint256) -> uint256: view\n', '    def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable\n', '    def add_liquidity(amounts: uint256[BASE_N_COINS], min_mint_amount: uint256): nonpayable\n', '    def remove_liquidity_one_coin(_token_amount: uint256, i: int128, min_amount: uint256): nonpayable\n', '\n', 'interface Factory:\n', '    def convert_fees() -> bool: nonpayable\n', '    def fee_receiver(_base_pool: address) -> address: view\n', '\n', 'event Transfer:\n', '    sender: indexed(address)\n', '    receiver: indexed(address)\n', '    value: uint256\n', '\n', 'event Approval:\n', '    owner: indexed(address)\n', '    spender: indexed(address)\n', '    value: uint256\n', '\n', 'event TokenExchange:\n', '    buyer: indexed(address)\n', '    sold_id: int128\n', '    tokens_sold: uint256\n', '    bought_id: int128\n', '    tokens_bought: uint256\n', '\n', 'event TokenExchangeUnderlying:\n', '    buyer: indexed(address)\n', '    sold_id: int128\n', '    tokens_sold: uint256\n', '    bought_id: int128\n', '    tokens_bought: uint256\n', '\n', 'event AddLiquidity:\n', '    provider: indexed(address)\n', '    token_amounts: uint256[N_COINS]\n', '    fees: uint256[N_COINS]\n', '    invariant: uint256\n', '    token_supply: uint256\n', '\n', 'event RemoveLiquidity:\n', '    provider: indexed(address)\n', '    token_amounts: uint256[N_COINS]\n', '    fees: uint256[N_COINS]\n', '    token_supply: uint256\n', '\n', 'event RemoveLiquidityOne:\n', '    provider: indexed(address)\n', '    token_amount: uint256\n', '    coin_amount: uint256\n', '    token_supply: uint256\n', '\n', 'event RemoveLiquidityImbalance:\n', '    provider: indexed(address)\n', '    token_amounts: uint256[N_COINS]\n', '    fees: uint256[N_COINS]\n', '    invariant: uint256\n', '    token_supply: uint256\n', '\n', 'event CommitNewAdmin:\n', '    deadline: indexed(uint256)\n', '    admin: indexed(address)\n', '\n', 'event NewAdmin:\n', '    admin: indexed(address)\n', '\n', 'event CommitNewFee:\n', '    deadline: indexed(uint256)\n', '    fee: uint256\n', '    admin_fee: uint256\n', '\n', 'event NewFee:\n', '    fee: uint256\n', '    admin_fee: uint256\n', '\n', 'event RampA:\n', '    old_A: uint256\n', '    new_A: uint256\n', '    initial_time: uint256\n', '    future_time: uint256\n', '\n', 'event StopRampA:\n', '    A: uint256\n', '    t: uint256\n', '\n', 'BASE_POOL: constant(address) = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7\n', 'BASE_COINS: constant(address[3]) = [\n', '    0x6B175474E89094C44Da98b954EedeAC495271d0F,  # DAI\n', '    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,  # USDC\n', '    0xdAC17F958D2ee523a2206206994597C13D831ec7,  # USDT\n', ']\n', '\n', 'N_COINS: constant(int128) = 2\n', 'MAX_COIN: constant(int128) = N_COINS - 1\n', 'BASE_N_COINS: constant(int128) = 3\n', 'PRECISION: constant(uint256) = 10 ** 18\n', '\n', 'FEE_DENOMINATOR: constant(uint256) = 10 ** 10\n', 'ADMIN_FEE: constant(uint256) = 5000000000\n', '\n', 'A_PRECISION: constant(uint256) = 100\n', 'MAX_A: constant(uint256) = 10 ** 6\n', 'MAX_A_CHANGE: constant(uint256) = 10\n', 'MIN_RAMP_TIME: constant(uint256) = 86400\n', '\n', 'admin: public(address)\n', 'factory: address\n', '\n', 'coins: public(address[N_COINS])\n', 'balances: public(uint256[N_COINS])\n', 'fee: public(uint256)  # fee * 1e10\n', '\n', 'initial_A: public(uint256)\n', 'future_A: public(uint256)\n', 'initial_A_time: public(uint256)\n', 'future_A_time: public(uint256)\n', '\n', 'rate_multiplier: uint256\n', '\n', 'name: public(String[64])\n', 'symbol: public(String[32])\n', '\n', 'balanceOf: public(HashMap[address, uint256])\n', 'allowance: public(HashMap[address, HashMap[address, uint256]])\n', 'totalSupply: public(uint256)\n', '\n', 'gauge: public(address)\n', '\n', 'crv_integral: uint256\n', 'crv_integral_for: HashMap[address, uint256]\n', 'claimable_crv: public(HashMap[address, uint256])\n', '\n', '# [uint216 claimable balance][uint40 timestamp]\n', 'last_claim_data: uint256\n', '\n', '@external\n', 'def __init__():\n', '    # we do this to prevent the implementation contract from being used as a pool\n', '    self.fee = 31337\n', '\n', '\n', '@external\n', 'def initialize(\n', '    _name: String[32],\n', '    _symbol: String[10],\n', '    _coin: address,\n', '    _decimals: uint256,\n', '    _A: uint256,\n', '    _fee: uint256,\n', '    _admin: address,\n', '\t_gauge: address,\n', '):\n', '    """\n', '    @notice Contract initializer\n', '    @param _name Name of the new pool\n', '    @param _symbol Token symbol\n', '    @param _coin Addresses of ERC20 conracts of coins\n', '    @param _decimals Number of decimals in `_coin`\n', '    @param _A Amplification coefficient multiplied by n * (n - 1)\n', '    @param _fee Fee to charge for exchanges\n', '    @param _admin Admin address\n', '    """\n', '    #  # things break if a token has >18 decimals\n', '    assert _decimals < 19\n', '    # fee must be between 0.04% and 1%\n', '    assert _fee >= 4000000\n', '    assert _fee <= 100000000\n', '    # check if fee was already set to prevent initializing contract twice\n', '    assert self.fee == 0\n', '\n', '    A: uint256 = _A * A_PRECISION\n', '    self.coins = [_coin, 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490]\n', '    self.rate_multiplier = 10 ** (36 - _decimals)\n', '    self.initial_A = A\n', '    self.future_A = A\n', '    self.fee = _fee\n', '    self.admin = _admin\n', '    self.factory = msg.sender\n', '\n', '    self.name = concat("Curve.fi Factory USD Metapool: ", _name)\n', '    self.symbol = concat(_symbol, "3CRV-f")\n', '\n', '    for coin in BASE_COINS:\n', '        ERC20(coin).approve(BASE_POOL, MAX_UINT256)\n', '\n', '    # fire a transfer event so block explorers identify the contract as an ERC20\n', '    log Transfer(ZERO_ADDRESS, self, 0)\n', '    \n', '    ERC20(LiquidityGauge(_gauge).lp_token()).approve(_gauge, MAX_UINT256)\n', '    self.gauge = _gauge\n', '\n', '### Gauge Functionality ###\n', '\n', '@internal\n', 'def _checkpoint(_user_addresses: address[2]):\n', '    claim_data: uint256 = self.last_claim_data\n', '    I: uint256 = self.crv_integral\n', '\n', '    if block.timestamp != claim_data % 2**40:\n', '        last_claimable: uint256 = shift(claim_data, -40)\n', '        claimable: uint256 = LiquidityGauge(self.gauge).claimable_tokens(self)\n', '        d_reward: uint256 = claimable - last_claimable\n', '        total_balance: uint256 = self.totalSupply\n', '        if total_balance > 0:\n', '            I += 10 ** 18 * d_reward / total_balance\n', '            self.crv_integral = I\n', '        self.last_claim_data = block.timestamp + shift(claimable, 40)\n', '\n', '    for addr in _user_addresses:\n', '        if addr in [ZERO_ADDRESS]:\n', '            # do not calculate an integral for the vault to ensure it cannot ever claim\n', '            continue\n', '        user_integral: uint256 = self.crv_integral_for[addr]\n', '        if user_integral < I:\n', '            user_balance: uint256 = self.balanceOf[addr]\n', '            self.claimable_crv[addr] += user_balance * (I - user_integral) / 10 ** 18\n', '            self.crv_integral_for[addr] = I\n', '\n', '\n', '@external\n', 'def user_checkpoint(addr: address) -> bool:\n', '    """\n', '    @notice Record a checkpoint for `addr`\n', '    @param addr User address\n', '    @return bool success\n', '    """\n', '    self._checkpoint([addr, ZERO_ADDRESS])\n', '    return True\n', '\n', '\n', '@external\n', 'def claimable_tokens(addr: address) -> uint256:\n', '    """\n', '    @notice Get the number of claimable tokens per user\n', '    @dev This function should be manually changed to "view" in the ABI\n', '    @return uint256 number of claimable tokens per user\n', '    """\n', '    self._checkpoint([addr, ZERO_ADDRESS])\n', '\n', '    return self.claimable_crv[addr]\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def claim_tokens(addr: address = msg.sender):\n', '    """\n', '    @notice Claim mintable CRV\n', '    @param addr Address to claim for\n', '    """\n', '    self._checkpoint([addr, ZERO_ADDRESS])\n', '\n', '    crv_token: address = LiquidityGauge(self.gauge).crv_token()\n', '    claimable: uint256 = self.claimable_crv[addr]\n', '    self.claimable_crv[addr] = 0\n', '\n', '    if ERC20(crv_token).balanceOf(self) < claimable:\n', '        Minter(LiquidityGauge(self.gauge).minter()).mint(self.gauge)\n', '        self.last_claim_data = block.timestamp\n', '\n', '    ERC20(crv_token).transfer(addr, claimable)\n', '    \n', '### ERC20 Functionality ###\n', '\n', '@view\n', '@external\n', 'def decimals() -> uint256:\n', '    """\n', '    @notice Get the number of decimals for this token\n', '    @dev Implemented as a view method to reduce gas costs\n', '    @return uint256 decimal places\n', '    """\n', '    return 18\n', '\n', '\n', '@internal\n', 'def _transfer(_from: address, _to: address, _value: uint256):\n', '    # NOTE: vyper does not allow underflows\n', '    #       so the following subtraction would revert on insufficient balance\n', '    self.balanceOf[_from] -= _value\n', '    self.balanceOf[_to] += _value\n', '\n', '    log Transfer(_from, _to, _value)\n', '\n', '\n', '@external\n', 'def transfer(_to : address, _value : uint256) -> bool:\n', '    """\n', '    @dev Transfer token for a specified address\n', '    @param _to The address to transfer to.\n', '    @param _value The amount to be transferred.\n', '    """\n', '    self._transfer(msg.sender, _to, _value)\n', '    return True\n', '\n', '\n', '@external\n', 'def transferFrom(_from : address, _to : address, _value : uint256) -> bool:\n', '    """\n', '     @dev Transfer tokens from one address to another.\n', '     @param _from address The address which you want to send tokens from\n', '     @param _to address The address which you want to transfer to\n', '     @param _value uint256 the amount of tokens to be transferred\n', '    """\n', '    self._transfer(_from, _to, _value)\n', '\n', '    _allowance: uint256 = self.allowance[_from][msg.sender]\n', '    if _allowance != MAX_UINT256:\n', '        self.allowance[_from][msg.sender] = _allowance - _value\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def approve(_spender : address, _value : uint256) -> bool:\n', '    """\n', '    @notice Approve the passed address to transfer the specified amount of\n', '            tokens on behalf of msg.sender\n', '    @dev Beware that changing an allowance via this method brings the risk that\n', '         someone may use both the old and new allowance by unfortunate transaction\n', '         ordering: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    @param _spender The address which will transfer the funds\n', '    @param _value The amount of tokens that may be transferred\n', '    @return bool success\n', '    """\n', '    self.allowance[msg.sender][_spender] = _value\n', '\n', '    log Approval(msg.sender, _spender, _value)\n', '    return True\n', '\n', '\n', '### StableSwap Functionality ###\n', '\n', '@view\n', '@internal\n', 'def _A() -> uint256:\n', '    """\n', '    Handle ramping A up or down\n', '    """\n', '    t1: uint256 = self.future_A_time\n', '    A1: uint256 = self.future_A\n', '\n', '    if block.timestamp < t1:\n', '        A0: uint256 = self.initial_A\n', '        t0: uint256 = self.initial_A_time\n', '        # Expressions in uint256 cannot have negative numbers, thus "if"\n', '        if A1 > A0:\n', '            return A0 + (A1 - A0) * (block.timestamp - t0) / (t1 - t0)\n', '        else:\n', '            return A0 - (A0 - A1) * (block.timestamp - t0) / (t1 - t0)\n', '\n', '    else:  # when t1 == 0 or block.timestamp >= t1\n', '        return A1\n', '\n', '@view\n', '@external\n', 'def admin_fee() -> uint256:\n', '    return ADMIN_FEE\n', '\n', '@view\n', '@external\n', 'def A() -> uint256:\n', '    return self._A() / A_PRECISION\n', '\n', '@view\n', '@external\n', 'def A_precise() -> uint256:\n', '    return self._A()\n', '\n', '@pure\n', '@internal\n', 'def _xp_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS]) -> uint256[N_COINS]:\n', '    result: uint256[N_COINS] = empty(uint256[N_COINS])\n', '    for i in range(N_COINS):\n', '        result[i] = _rates[i] * _balances[i] / PRECISION\n', '    return result\n', '\n', '@pure\n', '@internal\n', 'def get_D(_xp: uint256[N_COINS], _amp: uint256) -> uint256:\n', '    S: uint256 = 0\n', '    Dprev: uint256 = 0\n', '    for x in _xp:\n', '        S += x\n', '    if S == 0:\n', '        return 0\n', '\n', '    D: uint256 = S\n', '    Ann: uint256 = _amp * N_COINS\n', '    for i in range(255):\n', '        D_P: uint256 = D\n', '        for x in _xp:\n', '            D_P = D_P * D / (x * N_COINS)  # If division by 0, this will be borked: only withdrawal will work. And that is good\n', '        Dprev = D\n', '        D = (Ann * S / A_PRECISION + D_P * N_COINS) * D / ((Ann - A_PRECISION) * D / A_PRECISION + (N_COINS + 1) * D_P)\n', '        # Equality with the precision of 1\n', '        if D > Dprev:\n', '            if D - Dprev <= 1:\n', '                return D\n', '        else:\n', '            if Dprev - D <= 1:\n', '                return D\n', '    # convergence typically occurs in 4 rounds or less, this should be unreachable!\n', '    # if it does happen the pool is borked and LPs can withdraw via `remove_liquidity`\n', '    raise\n', '\n', '\n', '@view\n', '@internal\n', 'def get_D_mem(_rates: uint256[N_COINS], _balances: uint256[N_COINS], _amp: uint256) -> uint256:\n', '    xp: uint256[N_COINS] = self._xp_mem(_rates, _balances)\n', '    return self.get_D(xp, _amp)\n', '\n', '\n', '@view\n', '@external\n', 'def get_virtual_price() -> uint256:\n', '    """\n', '    @notice The current virtual price of the pool LP token\n', '    @dev Useful for calculating profits\n', '    @return LP token virtual price normalized to 1e18\n', '    """\n', '    amp: uint256 = self._A()\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '    xp: uint256[N_COINS] = self._xp_mem(rates, self.balances)\n', '    D: uint256 = self.get_D(xp, amp)\n', '    # D is in the units similar to DAI (e.g. converted to precision 1e18)\n', '    # When balanced, D = n * x_u - total virtual value of the portfolio\n', '    return D * PRECISION / self.totalSupply\n', '\n', '\n', '@view\n', '@external\n', 'def calc_token_amount(_amounts: uint256[N_COINS], _is_deposit: bool) -> uint256:\n', '    """\n', '    @notice Calculate addition or reduction in token supply from a deposit or withdrawal\n', '    @dev This calculation accounts for slippage, but not fees.\n', '         Needed to prevent front-running, not for precise calculations!\n', '    @param _amounts Amount of each coin being deposited\n', '    @param _is_deposit set True for deposits, False for withdrawals\n', '    @return Expected amount of LP tokens received\n', '    """\n', '    amp: uint256 = self._A()\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '    balances: uint256[N_COINS] = self.balances\n', '\n', '    D0: uint256 = self.get_D_mem(rates, balances, amp)\n', '    for i in range(N_COINS):\n', '        amount: uint256 = _amounts[i]\n', '        if _is_deposit:\n', '            balances[i] += amount\n', '        else:\n', '            balances[i] -= amount\n', '    D1: uint256 = self.get_D_mem(rates, balances, amp)\n', '    diff: uint256 = 0\n', '    if _is_deposit:\n', '        diff = D1 - D0\n', '    else:\n', '        diff = D0 - D1\n', '    return diff * self.totalSupply / D0\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def add_liquidity(\n', '    _amounts: uint256[N_COINS],\n', '    _min_mint_amount: uint256,\n', '    _receiver: address = msg.sender\n', ') -> uint256:\n', '    """\n', '    @notice Deposit coins into the pool\n', '    @param _amounts List of amounts of coins to deposit\n', '    @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit\n', '    @param _receiver Address that owns the minted LP tokens\n', '    @return Amount of LP tokens received by depositing\n', '    """\n', '    amp: uint256 = self._A()\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '\n', '    # Initial invariant\n', '    old_balances: uint256[N_COINS] = self.balances\n', '    D0: uint256 = self.get_D_mem(rates, old_balances, amp)\n', '    new_balances: uint256[N_COINS] = old_balances\n', '\n', '    total_supply: uint256 = self.totalSupply\n', '    for i in range(N_COINS):\n', '        amount: uint256 = _amounts[i]\n', '        if total_supply == 0:\n', '            assert amount > 0  # dev: initial deposit requires all coins\n', '        new_balances[i] += amount\n', '\n', '    # Invariant after change\n', '    D1: uint256 = self.get_D_mem(rates, new_balances, amp)\n', '    assert D1 > D0\n', '\n', '    # We need to recalculate the invariant accounting for fees\n', "    # to calculate fair user's share\n", '    fees: uint256[N_COINS] = empty(uint256[N_COINS])\n', '    mint_amount: uint256 = 0\n', '    if total_supply > 0:\n', '        # Only account for fees if we are not the first to deposit\n', '        base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))\n', '        for i in range(N_COINS):\n', '            ideal_balance: uint256 = D1 * old_balances[i] / D0\n', '            difference: uint256 = 0\n', '            new_balance: uint256 = new_balances[i]\n', '            if ideal_balance > new_balance:\n', '                difference = ideal_balance - new_balance\n', '            else:\n', '                difference = new_balance - ideal_balance\n', '            fees[i] = base_fee * difference / FEE_DENOMINATOR\n', '            self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)\n', '            new_balances[i] -= fees[i]\n', '        D2: uint256 = self.get_D_mem(rates, new_balances, amp)\n', '        mint_amount = total_supply * (D2 - D0) / D0\n', '    else:\n', '        self.balances = new_balances\n', '        mint_amount = D1  # Take the dust if there was any\n', '\n', '    assert mint_amount >= _min_mint_amount\n', '\n', '    # Take coins from the sender\n', '    for i in range(N_COINS):\n', '        amount: uint256 = _amounts[i]\n', '        if amount > 0:\n', '            ERC20(self.coins[i]).transferFrom(msg.sender, self, amount)  # dev: failed transfer\n', '    \n', '    if _amounts[MAX_COIN] > 0:\n', '        LiquidityGauge(self.gauge).deposit(_amounts[MAX_COIN])\n', '    \n', '    # Mint pool tokens\n', '    total_supply += mint_amount\n', '    self.balanceOf[_receiver] += mint_amount\n', '    self.totalSupply = total_supply\n', '    log Transfer(ZERO_ADDRESS, _receiver, mint_amount)\n', '    \n', '    self._checkpoint([msg.sender, ZERO_ADDRESS])\n', '\n', '    log AddLiquidity(msg.sender, _amounts, fees, D1, total_supply)\n', '\n', '    return mint_amount\n', '\n', '\n', '@view\n', '@internal\n', 'def get_y(i: int128, j: int128, x: uint256, xp: uint256[N_COINS]) -> uint256:\n', '    # x in the input is converted to the same price/precision\n', '\n', '    assert i != j       # dev: same coin\n', '    assert j >= 0       # dev: j below zero\n', '    assert j < N_COINS  # dev: j above N_COINS\n', '\n', '    # should be unreachable, but good for safety\n', '    assert i >= 0\n', '    assert i < N_COINS\n', '\n', '    amp: uint256 = self._A()\n', '    D: uint256 = self.get_D(xp, amp)\n', '    S_: uint256 = 0\n', '    _x: uint256 = 0\n', '    y_prev: uint256 = 0\n', '    c: uint256 = D\n', '    Ann: uint256 = amp * N_COINS\n', '\n', '    for _i in range(N_COINS):\n', '        if _i == i:\n', '            _x = x\n', '        elif _i != j:\n', '            _x = xp[_i]\n', '        else:\n', '            continue\n', '        S_ += _x\n', '        c = c * D / (_x * N_COINS)\n', '\n', '    c = c * D * A_PRECISION / (Ann * N_COINS)\n', '    b: uint256 = S_ + D * A_PRECISION / Ann  # - D\n', '    y: uint256 = D\n', '\n', '    for _i in range(255):\n', '        y_prev = y\n', '        y = (y*y + c) / (2 * y + b - D)\n', '        # Equality with the precision of 1\n', '        if y > y_prev:\n', '            if y - y_prev <= 1:\n', '                return y\n', '        else:\n', '            if y_prev - y <= 1:\n', '                return y\n', '    raise\n', '\n', '\n', '@view\n', '@external\n', 'def get_dy(i: int128, j: int128, dx: uint256) -> uint256:\n', '    """\n', '    @notice Calculate the current output dy given input dx\n', '    @dev Index values can be found via the `coins` public getter method\n', '    @param i Index value for the coin to send\n', '    @param j Index valie of the coin to recieve\n', '    @param dx Amount of `i` being exchanged\n', '    @return Amount of `j` predicted\n', '    """\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '    xp: uint256[N_COINS] = self.balances\n', '    xp = self._xp_mem(rates, xp)\n', '\n', '    x: uint256 = xp[i] + (dx * rates[i] / PRECISION)\n', '    y: uint256 = self.get_y(i, j, x, xp)\n', '    dy: uint256 = xp[j] - y - 1\n', '    fee: uint256 = self.fee * dy / FEE_DENOMINATOR\n', '    return (dy - fee) * PRECISION / rates[j]\n', '\n', '\n', '@view\n', '@external\n', 'def get_dy_underlying(i: int128, j: int128, dx: uint256) -> uint256:\n', '    """\n', '    @notice Calculate the current output dy given input dx on underlying\n', '    @dev Index values can be found via the `coins` public getter method\n', '    @param i Index value for the coin to send\n', '    @param j Index valie of the coin to recieve\n', '    @param dx Amount of `i` being exchanged\n', '    @return Amount of `j` predicted\n', '    """\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '    xp: uint256[N_COINS] = self.balances\n', '    xp = self._xp_mem(rates, xp)\n', '    base_pool: address = BASE_POOL\n', '\n', '    x: uint256 = 0\n', '    base_i: int128 = 0\n', '    base_j: int128 = 0\n', '    meta_i: int128 = 0\n', '    meta_j: int128 = 0\n', '\n', '    if i != 0:\n', '        base_i = i - MAX_COIN\n', '        meta_i = 1\n', '    if j != 0:\n', '        base_j = j - MAX_COIN\n', '        meta_j = 1\n', '\n', '    if i == 0:\n', '        x = xp[i] + dx * (rates[0] / 10**18)\n', '    else:\n', '        if j == 0:\n', '            # i is from BasePool\n', '            # At first, get the amount of pool tokens\n', '            base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])\n', '            base_inputs[base_i] = dx\n', '            # Token amount transformed to underlying "dollars"\n', '            x = Curve(base_pool).calc_token_amount(base_inputs, True) * rates[1] / PRECISION\n', '            # Accounting for deposit/withdraw fees approximately\n', '            x -= x * Curve(base_pool).fee() / (2 * FEE_DENOMINATOR)\n', '            # Adding number of pool tokens\n', '            x += xp[MAX_COIN]\n', '        else:\n', '            # If both are from the base pool\n', '            return Curve(base_pool).get_dy(base_i, base_j, dx)\n', '\n', '    # This pool is involved only when in-pool assets are used\n', '    y: uint256 = self.get_y(meta_i, meta_j, x, xp)\n', '    dy: uint256 = xp[meta_j] - y - 1\n', '    dy = (dy - self.fee * dy / FEE_DENOMINATOR)\n', '\n', '    # If output is going via the metapool\n', '    if j == 0:\n', '        dy /= (rates[0] / 10**18)\n', '    else:\n', '        # j is from BasePool\n', '        # The fee is already accounted for\n', '        dy = Curve(base_pool).calc_withdraw_one_coin(dy * PRECISION / rates[1], base_j)\n', '\n', '    return dy\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def exchange(\n', '    i: int128,\n', '    j: int128,\n', '    dx: uint256,\n', '    min_dy: uint256,\n', '    _receiver: address = msg.sender,\n', ') -> uint256:\n', '    """\n', '    @notice Perform an exchange between two coins\n', '    @dev Index values can be found via the `coins` public getter method\n', '    @param i Index value for the coin to send\n', '    @param j Index valie of the coin to recieve\n', '    @param dx Amount of `i` being exchanged\n', '    @param min_dy Minimum amount of `j` to receive\n', '    @param _receiver Address that receives `j`\n', '    @return Actual amount of `j` received\n', '    """\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '\n', '    old_balances: uint256[N_COINS] = self.balances\n', '    xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)\n', '\n', '    x: uint256 = xp[i] + dx * rates[i] / PRECISION\n', '    y: uint256 = self.get_y(i, j, x, xp)\n', '\n', '    dy: uint256 = xp[j] - y - 1  # -1 just in case there were some rounding errors\n', '    dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR\n', '\n', '    # Convert all to real units\n', '    dy = (dy - dy_fee) * PRECISION / rates[j]\n', '    assert dy >= min_dy\n', '\n', '    dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR\n', '    dy_admin_fee = dy_admin_fee * PRECISION / rates[j]\n', '\n', '    # Change balances exactly in same way as we change actual ERC20 coin amounts\n', '    self.balances[i] = old_balances[i] + dx\n', '    # When rounding errors happen, we undercharge admin fee in favor of LP\n', '    self.balances[j] = old_balances[j] - dy - dy_admin_fee\n', '\n', '    ERC20(self.coins[i]).transferFrom(msg.sender, self, dx)\n', '\t\n', '    if j == MAX_COIN:\n', '        LiquidityGauge(self.gauge).withdraw(dy)\n', '        \n', '    ERC20(self.coins[j]).transfer(_receiver, dy)\n', '\n', '    log TokenExchange(msg.sender, i, dx, j, dy)\n', '\n', '    return dy\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def exchange_underlying(\n', '    i: int128,\n', '    j: int128,\n', '    dx: uint256,\n', '    min_dy: uint256,\n', '    _receiver: address = msg.sender,\n', ') -> uint256:\n', '    """\n', '    @notice Perform an exchange between two underlying coins\n', '    @dev Index values can be found via the `underlying_coins` public getter method\n', '    @param i Index value for the underlying coin to send\n', '    @param j Index valie of the underlying coin to recieve\n', '    @param dx Amount of `i` being exchanged\n', '    @param min_dy Minimum amount of `j` to receive\n', '    @param _receiver Address that receives `j`\n', '    @return Actual amount of `j` received\n', '    """\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '    old_balances: uint256[N_COINS] = self.balances\n', '    xp: uint256[N_COINS] = self._xp_mem(rates, old_balances)\n', '\n', '    base_pool: address = BASE_POOL\n', '    base_coins: address[3] = BASE_COINS\n', '\n', '    dy: uint256 = 0\n', '    base_i: int128 = 0\n', '    base_j: int128 = 0\n', '    meta_i: int128 = 0\n', '    meta_j: int128 = 0\n', '    x: uint256 = 0\n', '    input_coin: address = ZERO_ADDRESS\n', '    output_coin: address = ZERO_ADDRESS\n', '\n', '    if i == 0:\n', '        input_coin = self.coins[0]\n', '    else:\n', '        base_i = i - MAX_COIN\n', '        meta_i = 1\n', '        input_coin = base_coins[base_i]\n', '    if j == 0:\n', '        output_coin = self.coins[0]\n', '    else:\n', '        base_j = j - MAX_COIN\n', '        meta_j = 1\n', '        output_coin = base_coins[base_j]\n', '\n', '    # Handle potential Tether fees\n', '    dx_w_fee: uint256 = dx\n', '    if j == 3:\n', '        dx_w_fee = ERC20(input_coin).balanceOf(self)\n', '\n', '    ERC20(input_coin).transferFrom(msg.sender, self, dx)\n', '\n', '    # Handle potential Tether fees\n', '    if j == 3:\n', '        dx_w_fee = ERC20(input_coin).balanceOf(self) - dx_w_fee\n', '\n', '    if i == 0 or j == 0:\n', '        if i == 0:\n', '            x = xp[i] + dx_w_fee * rates[i] / PRECISION\n', '        else:\n', '            # i is from BasePool\n', '            # At first, get the amount of pool tokens\n', '            base_inputs: uint256[BASE_N_COINS] = empty(uint256[BASE_N_COINS])\n', '            base_inputs[base_i] = dx_w_fee\n', '            coin_i: address = self.coins[MAX_COIN]\n', '            # Deposit and measure delta\n', '            x = ERC20(coin_i).balanceOf(self)\n', '            Curve(base_pool).add_liquidity(base_inputs, 0)\n', '            # Need to convert pool token to "virtual" units using rates\n', '            # dx is also different now\n', '            dx_w_fee = ERC20(coin_i).balanceOf(self) - x\n', '            x = dx_w_fee * rates[MAX_COIN] / PRECISION\n', '            # Adding number of pool tokens\n', '            x += xp[MAX_COIN]\n', '\n', '        y: uint256 = self.get_y(meta_i, meta_j, x, xp)\n', '\n', '        # Either a real coin or token\n', '        dy = xp[meta_j] - y - 1  # -1 just in case there were some rounding errors\n', '        dy_fee: uint256 = dy * self.fee / FEE_DENOMINATOR\n', '\n', '        # Convert all to real units\n', '        # Works for both pool coins and real coins\n', '        dy = (dy - dy_fee) * PRECISION / rates[meta_j]\n', '\n', '        dy_admin_fee: uint256 = dy_fee * ADMIN_FEE / FEE_DENOMINATOR\n', '        dy_admin_fee = dy_admin_fee * PRECISION / rates[meta_j]\n', '\n', '        # Change balances exactly in same way as we change actual ERC20 coin amounts\n', '        self.balances[meta_i] = old_balances[meta_i] + dx_w_fee\n', '        # When rounding errors happen, we undercharge admin fee in favor of LP\n', '        self.balances[meta_j] = old_balances[meta_j] - dy - dy_admin_fee\n', '\n', '        # Withdraw from the base pool if needed\n', '        if j > 0:\n', '            out_amount: uint256 = ERC20(output_coin).balanceOf(self)\n', '            LiquidityGauge(self.gauge).withdraw(dy)\n', '            Curve(base_pool).remove_liquidity_one_coin(dy, base_j, 0)\n', '            dy = ERC20(output_coin).balanceOf(self) - out_amount\n', '\n', '        assert dy >= min_dy\n', '\n', '    else:\n', '        # If both are from the base pool\n', '        dy = ERC20(output_coin).balanceOf(self)\n', '        Curve(base_pool).exchange(base_i, base_j, dx_w_fee, min_dy)\n', '        dy = ERC20(output_coin).balanceOf(self) - dy\n', '\n', '    ERC20(output_coin).transfer(_receiver, dy)\n', '\n', '    log TokenExchangeUnderlying(msg.sender, i, dx, j, dy)\n', '\n', '    return dy\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def remove_liquidity(\n', '    _burn_amount: uint256,\n', '    _min_amounts: uint256[N_COINS],\n', '    _receiver: address = msg.sender\n', ') -> uint256[N_COINS]:\n', '    """\n', '    @notice Withdraw coins from the pool\n', '    @dev Withdrawal amounts are based on current deposit ratios\n', '    @param _burn_amount Quantity of LP tokens to burn in the withdrawal\n', '    @param _min_amounts Minimum amounts of underlying coins to receive\n', '    @param _receiver Address that receives the withdrawn coins\n', '    @return List of amounts of coins that were withdrawn\n', '    """\n', '    total_supply: uint256 = self.totalSupply\n', '    amounts: uint256[N_COINS] = empty(uint256[N_COINS])\n', '\n', '    for i in range(N_COINS):\n', '        old_balance: uint256 = self.balances[i]\n', '        value: uint256 = old_balance * _burn_amount / total_supply\n', '        assert value >= _min_amounts[i]\n', '        self.balances[i] = old_balance - value\n', '        amounts[i] = value\n', '        if i == MAX_COIN:\n', '            LiquidityGauge(self.gauge).withdraw(value)\n', '        ERC20(self.coins[i]).transfer(_receiver, value)\n', '\n', '    total_supply -= _burn_amount\n', '    self.balanceOf[msg.sender] -= _burn_amount\n', '    self.totalSupply = total_supply\n', '    log Transfer(msg.sender, ZERO_ADDRESS, _burn_amount)\n', '\n', '    log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply)\n', '\n', '    return amounts\n', '\n', '\n', '@external\n', "@nonreentrant('lock')\n", 'def remove_liquidity_imbalance(\n', '    _amounts: uint256[N_COINS],\n', '    _max_burn_amount: uint256,\n', '    _receiver: address = msg.sender\n', ') -> uint256:\n', '    """\n', '    @notice Withdraw coins from the pool in an imbalanced amount\n', '    @param _amounts List of amounts of underlying coins to withdraw\n', '    @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal\n', '    @param _receiver Address that receives the withdrawn coins\n', '    @return Actual amount of the LP token burned in the withdrawal\n', '    """\n', '\n', '    amp: uint256 = self._A()\n', '    rates: uint256[N_COINS] = [self.rate_multiplier, Curve(BASE_POOL).get_virtual_price()]\n', '    old_balances: uint256[N_COINS] = self.balances\n', '    D0: uint256 = self.get_D_mem(rates, old_balances, amp)\n', '\n', '    new_balances: uint256[N_COINS] = old_balances\n', '    for i in range(N_COINS):\n', '        new_balances[i] -= _amounts[i]\n', '    D1: uint256 = self.get_D_mem(rates, new_balances, amp)\n', '\n', '    fees: uint256[N_COINS] = empty(uint256[N_COINS])\n', '    base_fee: uint256 = self.fee * N_COINS / (4 * (N_COINS - 1))\n', '    for i in range(N_COINS):\n', '        ideal_balance: uint256 = D1 * old_balances[i] / D0\n', '        difference: uint256 = 0\n', '        new_balance: uint256 = new_balances[i]\n', '        if ideal_balance > new_balance:\n', '            difference = ideal_balance - new_balance\n', '        else:\n', '            difference = new_balance - ideal_balance\n', '        fees[i] = base_fee * difference / FEE_DENOMINATOR\n', '        self.balances[i] = new_balance - (fees[i] * ADMIN_FEE / FEE_DENOMINATOR)\n', '        new_balances[i] -= fees[i]\n', '    D2: uint256 = self.get_D_mem(rates, new_balances, amp)\n', '\n', '    total_supply: uint256 = self.totalSupply\n', '    burn_amount: uint256 = ((D0 - D2) * total_supply / D0) + 1\n', '    assert burn_amount > 1  # dev: zero tokens burned\n', '    assert burn_amount <= _max_burn_amount\n', '\n', '    total_supply -= burn_amount\n', '    self.totalSupply = total_supply\n', '    self.balanceOf[msg.sender] -= burn_amount\n', '    log Transfer(msg.sender, ZERO_ADDRESS, burn_amount)\n', '\n', '    for i in range(N_COINS):\n', '        amount: uint256 = _amounts[i]\n', '        if i == MAX_COIN:\n', '                LiquidityGauge(self.gauge).withdraw(amount)\n', '        if amount != 0:    \n', '            ERC20(self.coins[i]).transfer(_receiver, amount)\n', '\n', '    log RemoveLiquidityImbalance(msg.sender, _amounts, fees, D1, total_supply)\n', '\n', '    return burn_amount\n', '\n', '\n', '@view\n', '@internal\n', 'def get_y_D(A: uint256, i: int128, xp: uint256[N_COINS], D: uint256) -> uint256:\n', '    """\n', '    Calculate x[i] if one reduces D from being calculated for xp to D\n', '\n', '    Done by solving quadratic equation iteratively.\n', "    x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)\n", '    x_1**2 + b*x_1 = c\n', '\n', '    x_1 = (x_1**2 + c) / (2*x_1 + b)\n', '    """\n', '    # x in the input is converted to the same price/precision\n', '\n', '    assert i >= 0  # dev: i below zero\n', '    assert i < N_COINS  # dev: i above N_COINS\n', '\n', '    S_: uint256 = 0\n', '    _x: uint256 = 0\n', '    y_prev: uint256 = 0\n', '    c: uint256 = D\n', '    Ann: uint256 = A * N_COINS\n', '\n', '    for _i in range(N_COINS):\n', '        if _i != i:\n', '            _x = xp[_i]\n', '        else:\n', '            continue\n', '        S_ += _x\n', '        c = c * D / (_x * N_COINS)\n', '\n', '    c = c * D * A_PRECISION / (Ann * N_COINS)\n', '    b: uint256 = S_ + D * A_PRECISION / Ann\n', '    y: uint256 = D\n', '\n', '    for _i in range(255):\n', '        y_prev = y\n', '        y = (y*y + c) / (2 * y + b - D)\n', '        # Equality with the precision of 1\n', '        if y > y_prev:\n', '            if y - y_prev <= 1:\n', '                return y\n', '        else:\n', '            if y_prev - y <= 1:\n', '                return y\n', '    raise\n', '\n', '\n', '@external\n', 'def ramp_A(_future_A: uint256, _future_time: uint256):\n', '    assert msg.sender == self.admin  # dev: only owner\n', '    assert block.timestamp >= self.initial_A_time + MIN_RAMP_TIME\n', '    assert _future_time >= block.timestamp + MIN_RAMP_TIME  # dev: insufficient time\n', '\n', '    _initial_A: uint256 = self._A()\n', '    _future_A_p: uint256 = _future_A * A_PRECISION\n', '\n', '    assert _future_A > 0 and _future_A < MAX_A\n', '    if _future_A_p < _initial_A:\n', '        assert _future_A_p * MAX_A_CHANGE >= _initial_A\n', '    else:\n', '        assert _future_A_p <= _initial_A * MAX_A_CHANGE\n', '\n', '    self.initial_A = _initial_A\n', '    self.future_A = _future_A_p\n', '    self.initial_A_time = block.timestamp\n', '    self.future_A_time = _future_time\n', '\n', '    log RampA(_initial_A, _future_A_p, block.timestamp, _future_time)\n', '\n', '\n', '@external\n', 'def stop_ramp_A():\n', '    assert msg.sender == self.admin  # dev: only owner\n', '\n', '    current_A: uint256 = self._A()\n', '    self.initial_A = current_A\n', '    self.future_A = current_A\n', '    self.initial_A_time = block.timestamp\n', '    self.future_A_time = block.timestamp\n', '    # now (block.timestamp < t1) is always False, so we return saved A\n', '\n', '    log StopRampA(current_A, block.timestamp)\n', '\n', '\n', '@view\n', '@external\n', 'def admin_balances(i: uint256) -> uint256:\n', '    return ERC20(self.coins[i]).balanceOf(self) - self.balances[i]\n', '\n', '\n', '@external\n', 'def withdraw_admin_fees():\n', '    factory: address = self.factory\n', '\n', '    # transfer coin 0 to Factory and call `convert_fees` to swap it for coin 1\n', '    coin: address = self.coins[0]\n', '    amount: uint256 = ERC20(coin).balanceOf(self) - self.balances[0]\n', '    if amount > 0:\n', '        ERC20(coin).transfer(factory, amount)\n', '        Factory(factory).convert_fees()\n', '\n', '    # transfer coin 1 to the receiver\n', '    coin = self.coins[1]\n', '    amount = ERC20(coin).balanceOf(self) - self.balances[1]\n', '    if amount > 0:\n', '        receiver: address = Factory(factory).fee_receiver(BASE_POOL)\n', '        ERC20(coin).transfer(receiver, amount)']