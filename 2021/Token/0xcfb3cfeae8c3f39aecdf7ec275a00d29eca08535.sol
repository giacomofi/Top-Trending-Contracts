['# @version 0.2.12\n', '# (c) Curve.Fi, 2021\n', '\n', '# This contract contains view-only external methods which can be gas-inefficient\n', '# when called from smart contracts but ok to use from frontend\n', '# Called only from Curve contract as it uses msg.sender as the contract address\n', 'from vyper.interfaces import ERC20\n', '\n', 'interface Curve:\n', '    def A_precise() -> uint256: view\n', '    def gamma() -> uint256: view\n', '    def price_scale(i: uint256) -> uint256: view\n', '    def balances(i: uint256) -> uint256: view\n', '    def D() -> uint256: view\n', '    def fee_calc(xp: uint256[N_COINS]) -> uint256: view\n', '    def calc_token_fee(amounts: uint256[N_COINS], xp: uint256[N_COINS]) -> uint256: view\n', '    def token() -> address: view\n', '\n', 'interface Math:\n', '    def newton_D(ANN: uint256, gamma: uint256, x_unsorted: uint256[N_COINS]) -> uint256: view\n', '    def newton_y(ANN: uint256, gamma: uint256, x: uint256[N_COINS], D: uint256, i: uint256) -> uint256: view\n', '\n', 'N_COINS: constant(int128) = 3  # <- change\n', 'PRECISION: constant(uint256) = 10 ** 18  # The precision to convert to\n', 'PRECISIONS: constant(uint256[N_COINS]) = [\n', '    10**12, # USDT\n', '    10**10, # WBTC\n', '    1, # WETH\n', ']\n', '\n', 'math: address\n', '\n', '\n', '@external\n', 'def __init__(math: address):\n', '    self.math = math\n', '\n', '\n', '@external\n', '@view\n', 'def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256:\n', '    assert i != j and i < N_COINS and j < N_COINS, "coin index out of range"\n', '    assert dx > 0, "do not exchange 0 coins"\n', '\n', '    precisions: uint256[N_COINS] = PRECISIONS\n', '\n', '    price_scale: uint256[N_COINS-1] = empty(uint256[N_COINS-1])\n', '    for k in range(N_COINS-1):\n', '        price_scale[k] = Curve(msg.sender).price_scale(k)\n', '    xp: uint256[N_COINS] = empty(uint256[N_COINS])\n', '    for k in range(N_COINS):\n', '        xp[k] = Curve(msg.sender).balances(k)\n', '    y0: uint256 = xp[j]\n', '    xp[i] += dx\n', '    xp[0] *= precisions[0]\n', '    for k in range(N_COINS-1):\n', '        xp[k+1] = xp[k+1] * price_scale[k] * precisions[k+1] / PRECISION\n', '\n', '    A: uint256 = Curve(msg.sender).A_precise()\n', '    gamma: uint256 = Curve(msg.sender).gamma()\n', '\n', '    y: uint256 = Math(self.math).newton_y(A, gamma, xp, Curve(msg.sender).D(), j)\n', '    dy: uint256 = xp[j] - y - 1\n', '    xp[j] = y\n', '    if j > 0:\n', '        dy = dy * PRECISION / price_scale[j-1]\n', '    dy /= precisions[j]\n', '    dy -= Curve(msg.sender).fee_calc(xp) * dy / 10**10\n', '\n', '    return dy\n', '\n', '\n', '@view\n', '@external\n', 'def calc_token_amount(amounts: uint256[N_COINS], deposit: bool) -> uint256:\n', '    precisions: uint256[N_COINS] = PRECISIONS\n', '    token_supply: uint256 = ERC20(Curve(msg.sender).token()).totalSupply()\n', '    xp: uint256[N_COINS] = empty(uint256[N_COINS])\n', '    for k in range(N_COINS):\n', '        xp[k] = Curve(msg.sender).balances(k)\n', '    amountsp: uint256[N_COINS] = amounts\n', '    if deposit:\n', '        for k in range(N_COINS):\n', '            xp[k] += amounts[k]\n', '    else:\n', '        for k in range(N_COINS):\n', '            xp[k] -= amounts[k]\n', '    xp[0] *= precisions[0]\n', '    amountsp[0] *= precisions[0]\n', '    for k in range(N_COINS-1):\n', '        p: uint256 = Curve(msg.sender).price_scale(k) * precisions[k+1]\n', '        xp[k+1] = xp[k+1] * p / PRECISION\n', '        amountsp[k+1] = amountsp[k+1] * p / PRECISION\n', '    A: uint256 = Curve(msg.sender).A_precise()\n', '    gamma: uint256 = Curve(msg.sender).gamma()\n', '    D: uint256 = Math(self.math).newton_D(A, gamma, xp)\n', '    d_token: uint256 = token_supply * D / Curve(msg.sender).D()\n', '    if deposit:\n', '        d_token -= token_supply\n', '    else:\n', '        d_token = token_supply - d_token\n', '    d_token -= Curve(msg.sender).calc_token_fee(amountsp, xp) * d_token / 10**10 + 1\n', '    return d_token']