['# @version 0.2.12\n', '\n', '"""\n', '@title Unagii EthVault V2\n', '@author stakewith.us\n', '@license AGPL-3.0-or-later\n', '"""\n', '\n', 'from vyper.interfaces import ERC20\n', '\n', '\n', 'interface UnagiiToken:\n', '    def minter() -> address: view\n', '    def token() -> address: view\n', '    def decimals() -> uint256: view\n', '    def totalSupply() -> uint256: view\n', '    def balanceOf(owner: address) -> uint256: view\n', '    def mint(receiver: address, amount: uint256): nonpayable\n', '    def burn(spender: address, amount: uint256): nonpayable\n', '    def lastBlock(owner: address) -> uint256: view\n', '\n', '\n', '# used for migrating to new Vault contract\n', 'interface Vault:\n', '    def oldVault() -> address: view\n', '    def token() -> address: view\n', '    def uToken() -> address: view\n', '    def fundManager() -> address: view\n', '    def initialize(): payable\n', '    def balanceOfVault() -> uint256: view\n', '    def debt() -> uint256: view\n', '    def lockedProfit() -> uint256: view\n', '    def lastReport() -> uint256: view\n', '\n', '\n', 'interface FundManager:\n', '    def vault() -> address: view\n', '    def token() -> address: view\n', '    # returns loss = debt - total assets in fund manager\n', '    def withdraw(amount: uint256) -> uint256: nonpayable\n', '\n', '\n', 'event Migrate:\n', '    vault: address\n', '    balanceOfVault: uint256\n', '    debt: uint256\n', '    lockedProfit: uint256\n', '\n', '\n', 'event SetNextTimeLock:\n', '    nextTimeLock: address\n', '\n', '\n', 'event AcceptTimeLock:\n', '    timeLock: address\n', '\n', '\n', 'event SetGuardian:\n', '    guardian: address\n', '\n', '\n', 'event SetAdmin:\n', '    admin: address\n', '\n', '\n', 'event SetFundManager:\n', '    fundManager: address\n', '\n', '\n', 'event SetPause:\n', '    paused: bool\n', '\n', '\n', 'event SetWhitelist:\n', '    addr: indexed(address)\n', '    approved: bool\n', '\n', '\n', 'event ReceiveEth:\n', '    sender: indexed(address)\n', '    amount: uint256\n', '\n', '\n', 'event Deposit:\n', '    sender: indexed(address)\n', '    amount: uint256\n', '    shares: uint256\n', '\n', '\n', 'event Withdraw:\n', '    owner: indexed(address)\n', '    shares: uint256\n', '    amount: uint256\n', '\n', '\n', 'event Borrow:\n', '    fundManager: indexed(address)\n', '    amount: uint256\n', '    borrowed: uint256\n', '\n', '\n', 'event Repay:\n', '    fundManager: indexed(address)\n', '    amount: uint256\n', '    repaid: uint256\n', '\n', '\n', 'event Report:\n', '    fundManager: indexed(address)\n', '    balanceOfVault: uint256\n', '    debt: uint256\n', '    gain: uint256\n', '    loss: uint256\n', '    diff: uint256\n', '    lockedProfit: uint256\n', '\n', '\n', 'event ForceUpdateBalanceOfVault:\n', '    balanceOfVault: uint256\n', '\n', '\n', 'initialized: public(bool)\n', 'paused: public(bool)\n', '\n', 'ETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE\n', 'uToken: public(UnagiiToken)\n', 'fundManager: public(FundManager)\n', '# privileges: time lock >= admin >= guardian\n', 'timeLock: public(address)\n', 'nextTimeLock: public(address)\n', 'guardian: public(address)\n', 'admin: public(address)\n', '\n', 'depositLimit: public(uint256)\n', '# ETH balance of vault tracked internally to protect against share dilution\n', '# from sending ETH directly to this contract\n', 'balanceOfVault: public(uint256)\n', 'debt: public(uint256)  # debt to users (amount borrowed by fund manager)\n', '# minimum amount of ETH to be kept in this vault for cheap withdraw\n', 'minReserve: public(uint256)\n', 'MAX_MIN_RESERVE: constant(uint256) = 10000\n', '# timestamp of last report\n', 'lastReport: public(uint256)\n', '# profit locked from report, released over time at a rate set by lockedProfitDegradation\n', 'lockedProfit: public(uint256)\n', 'MAX_DEGRADATION: constant(uint256) = 10 ** 18\n', '# rate at which locked profit is released\n', '# 0 = forever, MAX_DEGREDATION = 100% of profit is released 1 block after report\n', 'lockedProfitDegradation: public(uint256)\n', '# minimum number of block to wait before deposit / withdraw\n', '# used to protect agains flash attacks\n', 'blockDelay: public(uint256)\n', '# whitelisted address can bypass block delay check\n', 'whitelist: public(HashMap[address, bool])\n', '\n', '# address of old Vault contract, used for migration\n', 'oldVault: public(Vault)\n', '\n', '\n', '@external\n', 'def __init__(uToken: address, guardian: address, oldVault: address):\n', '    self.timeLock = msg.sender\n', '    self.admin = msg.sender\n', '    self.guardian = guardian\n', '    self.uToken = UnagiiToken(uToken)\n', '\n', '    assert self.uToken.token() == ETH, "uToken token != ETH"\n', '\n', '    self.paused = True\n', '    self.blockDelay = 1\n', '    self.minReserve = 500  # 5% of free funds\n', '    # 6 hours\n', '    self.lockedProfitDegradation = convert(MAX_DEGRADATION / 21600, uint256)\n', '\n', '    if oldVault != ZERO_ADDRESS:\n', '        self.oldVault = Vault(oldVault)\n', '        assert self.oldVault.token() == ETH, "old vault token != ETH"\n', '        assert self.oldVault.uToken() == uToken, "old vault uToken != uToken"\n', '\n', '\n', '@external\n', '@payable\n', 'def __default__():\n', '    """\n', '    @dev Prevent users from accidentally sending ETH to this vault\n', '    """\n', '    assert msg.sender == self.fundManager.address, "!fund manager"\n', '    log ReceiveEth(msg.sender, msg.value)\n', '\n', '\n', '@external\n', '@view\n', 'def token() -> address:\n', '    return ETH\n', '\n', '\n', '@internal\n', 'def _sendEth(to: address, amount: uint256):\n', '    assert to != ZERO_ADDRESS, "to = 0 address"\n', '    raw_call(to, b"", value=amount)\n', '\n', '\n', '@internal\n', 'def _safeTransfer(token: address, receiver: address, amount: uint256):\n', '    res: Bytes[32] = raw_call(\n', '        token,\n', '        concat(\n', '            method_id("transfer(address,uint256)"),\n', '            convert(receiver, bytes32),\n', '            convert(amount, bytes32),\n', '        ),\n', '        max_outsize=32,\n', '    )\n', '    if len(res) > 0:\n', '        assert convert(res, bool), "transfer failed"\n', '\n', '\n', '@external\n', '@payable\n', 'def initialize():\n', '    """\n', '    @notice Initialize vault. Transfer ETH and copy states if old vault is set.\n', '    """\n', '    assert not self.initialized, "initialized"\n', '\n', '    if self.oldVault.address == ZERO_ADDRESS:\n', '        assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '        self.lastReport = block.timestamp\n', '    else:\n', '        assert msg.sender == self.oldVault.address, "!old vault"\n', '\n', '        assert self.uToken.minter() == self, "minter != self"\n', '\n', '        assert (\n', '            self.fundManager.address == self.oldVault.fundManager()\n', '        ), "fund manager != old vault fund manager"\n', '        if self.fundManager.address != ZERO_ADDRESS:\n', '            assert self.fundManager.vault() == self, "fund manager vault != self"\n', '\n', '        # check ETH sent from old vault >= old balanceOfVault\n', '        balOfVault: uint256 = self.oldVault.balanceOfVault()\n', '        assert msg.value >= balOfVault, "value < vault"\n', '\n', '        self.balanceOfVault = min(balOfVault, msg.value)\n', '        self.debt = self.oldVault.debt()\n', '        self.lockedProfit = self.oldVault.lockedProfit()\n', '        self.lastReport = self.oldVault.lastReport()\n', '\n', '    self.initialized = True\n', '\n', '\n', '# Migration steps from this vault to new vault\n', '#\n', '# ut = unagi token\n', '# v1 = vault 1\n', '# v2 = vault 2\n', '# f = fund manager\n', '#\n', '# action                         | caller\n', '# ----------------------------------------\n', '# 1. v2.setPause(true)           | admin\n', '# 2. v1.setPause(true)           | admin\n', '# 3. ut.setMinter(v2)            | time lock\n', '# 4. f.setVault(v2)              | time lock\n', '# 5. v2.setFundManager(f)        | time lock\n', '# 6. transfer ETH                | v1\n', '# 7. v2 copy states from v1      | v2\n', '#    - balanceOfVault            |\n', '#    - debt                      |\n', '#    - locked profit             |\n', '#    - last report               |\n', '# 8. v1 set state = 0            | v1\n', '#    - balanceOfVault            |\n', '#    - debt                      |\n', '#    - locked profit             |\n', '\n', '\n', '@external\n', 'def migrate(vault: address):\n', '    """\n', '    @notice Migrate to new vault\n', '    @param vault Address of new vault\n', '    """\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '    assert self.initialized, "!initialized"\n', '    assert self.paused, "!paused"\n', '\n', '    assert Vault(vault).token() == ETH, "new vault token != ETH"\n', '    assert Vault(vault).uToken() == self.uToken.address, "new vault uToken != uToken"\n', '    # minter is set to new vault\n', '    assert self.uToken.minter() == vault, "minter != new vault"\n', "    # new vault's fund manager is set to current fund manager\n", '    assert (\n', '        Vault(vault).fundManager() == self.fundManager.address\n', '    ), "new vault fund manager != fund manager"\n', '    if self.fundManager.address != ZERO_ADDRESS:\n', "        # fund manager's vault is set to new vault\n", '        assert self.fundManager.vault() == vault, "fund manager vault != new vault"\n', '\n', '    # check balance of vault >= balanceOfVault\n', '    bal: uint256 = self.balance\n', '    assert bal >= self.balanceOfVault, "bal < vault"\n', '\n', '    assert Vault(vault).oldVault() == self, "old vault != self"\n', '\n', '    Vault(vault).initialize(value=bal)\n', '\n', '    log Migrate(vault, self.balanceOfVault, self.debt, self.lockedProfit)\n', '\n', '    # reset state\n', '    self.balanceOfVault = 0\n', '    self.debt = 0\n', '    self.lockedProfit = 0\n', '\n', '\n', '@external\n', 'def setNextTimeLock(nextTimeLock: address):\n', '    """\n', '    @notice Set next time lock\n', '    @param nextTimeLock Address of next time lock\n', '    """\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '    self.nextTimeLock = nextTimeLock\n', '    log SetNextTimeLock(nextTimeLock)\n', '\n', '\n', '@external\n', 'def acceptTimeLock():\n', '    """\n', '    @notice Accept time lock\n', '    @dev Only `nextTimeLock` can claim time lock\n', '    """\n', '    assert msg.sender == self.nextTimeLock, "!next time lock"\n', '    self.timeLock = msg.sender\n', '    log AcceptTimeLock(msg.sender)\n', '\n', '\n', '@external\n', 'def setAdmin(admin: address):\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    self.admin = admin\n', '    log SetAdmin(admin)\n', '\n', '\n', '@external\n', 'def setGuardian(guardian: address):\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    self.guardian = guardian\n', '    log SetGuardian(guardian)\n', '\n', '\n', '@external\n', 'def setFundManager(fundManager: address):\n', '    """\n', '    @notice Set fund manager\n', '    @param fundManager Address of new fund manager\n', '    """\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '\n', '    assert FundManager(fundManager).vault() == self, "fund manager vault != self"\n', '    assert FundManager(fundManager).token() == ETH, "fund manager token != ETH"\n', '\n', '    self.fundManager = FundManager(fundManager)\n', '    log SetFundManager(fundManager)\n', '\n', '\n', '@external\n', 'def setPause(paused: bool):\n', '    assert msg.sender in [self.timeLock, self.admin, self.guardian], "!auth"\n', '    self.paused = paused\n', '    log SetPause(paused)\n', '\n', '\n', '@external\n', 'def setMinReserve(minReserve: uint256):\n', '    """\n', '    @notice Set minimum amount of ETH reserved in this vault for cheap\n', '            withdrawn by user\n', '    @param minReserve Numerator to calculate min reserve\n', '           0 = all funds can be transferred to fund manager\n', '           MAX_MIN_RESERVE = 0 ETH can be transferred to fund manager\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    assert minReserve <= MAX_MIN_RESERVE, "min reserve > max"\n', '    self.minReserve = minReserve\n', '\n', '\n', '@external\n', 'def setLockedProfitDegradation(degradation: uint256):\n', '    """\n', '    @notice Set locked profit degradation (rate locked profit is released)\n', '    @param degradation Rate of degradation\n', '                 0 = profit is locked forever\n', '                 MAX_DEGRADATION = 100% of profit is released 1 block after report\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    assert degradation <= MAX_DEGRADATION, "degradation > max"\n', '    self.lockedProfitDegradation = degradation\n', '\n', '\n', '@external\n', 'def setDepositLimit(limit: uint256):\n', '    """\n', '    @notice Set limit to total deposit\n', '    @param limit Limit for total deposit\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    self.depositLimit = limit\n', '\n', '\n', '@external\n', 'def setBlockDelay(delay: uint256):\n', '    """\n', '    @notice Set block delay, used to protect against flash attacks\n', '    @param delay Number of blocks to delay before user can deposit / withdraw\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    assert delay >= 1, "delay = 0"\n', '    self.blockDelay = delay\n', '\n', '\n', '@external\n', 'def setWhitelist(addr: address, approved: bool):\n', '    """\n', '    @notice Approve or disapprove address to skip check on block delay.\n', '            Approved address can deposit, withdraw and transfer uToken in\n', '            a single transaction\n', '    @param approved Boolean True = approve\n', '                             False = disapprove\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    self.whitelist[addr] = approved\n', '    log SetWhitelist(addr, approved)\n', '\n', '\n', '@internal\n', '@view\n', 'def _totalAssets() -> uint256:\n', '    """\n', '    @notice Total amount of ETH in this vault + amount in fund manager\n', '    @dev State variable `balanceOfVault` is used to track balance of ETH in\n', '         this contract instead of `self.balance`. This is done to\n', '         protect against uToken shares being diluted by directly sending ETH\n', '         to this contract.\n', '    @dev Returns total amount of ETH in this contract\n', '    """\n', '    return self.balanceOfVault + self.debt\n', '\n', '\n', '@external\n', '@view\n', 'def totalAssets() -> uint256:\n', '    return self._totalAssets()\n', '\n', '\n', '@internal\n', '@view\n', 'def _calcLockedProfit() -> uint256:\n', '    """\n', '    @notice Calculated locked profit\n', '    @dev Returns amount of profit locked from last report. Profit is released\n', '         over time, depending on the release rate `lockedProfitDegradation`.\n', '         Profit is locked after `report` to protect against sandwich attack.\n', '    """\n', '    lockedFundsRatio: uint256 = (\n', '        block.timestamp - self.lastReport\n', '    ) * self.lockedProfitDegradation\n', '\n', '    if lockedFundsRatio < MAX_DEGRADATION:\n', '        lockedProfit: uint256 = self.lockedProfit\n', '        return lockedProfit - lockedFundsRatio * lockedProfit / MAX_DEGRADATION\n', '    else:\n', '        return 0\n', '\n', '\n', '@external\n', '@view\n', 'def calcLockedProfit() -> uint256:\n', '    return self._calcLockedProfit()\n', '\n', '\n', '@internal\n', '@view\n', 'def _calcFreeFunds() -> uint256:\n', '    """\n', '    @notice Calculate free funds (total assets - locked profit)\n', '    @dev Returns total amount of ETH that can be withdrawn\n', '    """\n', '    return self._totalAssets() - self._calcLockedProfit()\n', '\n', '\n', '@external\n', '@view\n', 'def calcFreeFunds() -> uint256:\n', '    return self._calcFreeFunds()\n', '\n', '\n', '@internal\n', '@pure\n', 'def _calcSharesToMint(\n', '    amount: uint256, totalSupply: uint256, freeFunds: uint256\n', ') -> uint256:\n', '    """\n', '    @notice Calculate uToken shares to mint\n', '    @param amount Amount of ETH to deposit\n', '    @param totalSupply Total amount of shares\n', '    @param freeFunds Free funds before deposit\n', '    @dev Returns amount of uToken to mint. Input must be numbers before deposit\n', '    @dev Calculated with `freeFunds`, not `totalAssets`\n', '    """\n', '    # s = shares to mint\n', '    # T = total shares before mint\n', '    # a = deposit amount\n', '    # P = total amount of ETH in vault + fund manager before deposit\n', '    # s / (T + s) = a / (P + a)\n', '    # sP = aT\n', '    # a = 0               | mint s = 0\n', '    # a > 0, T = 0, P = 0 | mint s = a\n', '    # a > 0, T = 0, P > 0 | mint s = a as if P = 0\n', '    # a > 0, T > 0, P = 0 | invalid, equation cannot be true for any s\n', '    # a > 0, T > 0, P > 0 | mint s = aT / P\n', '    if amount == 0:\n', '        return 0\n', '    if totalSupply == 0:\n', '        return amount\n', '    # reverts if free funds = 0\n', '    return amount * totalSupply / freeFunds\n', '\n', '\n', '@external\n', '@view\n', 'def calcSharesToMint(amount: uint256) -> uint256:\n', '    return self._calcSharesToMint(\n', '        amount, self.uToken.totalSupply(), self._calcFreeFunds()\n', '    )\n', '\n', '\n', '@internal\n', '@pure\n', 'def _calcWithdraw(shares: uint256, totalSupply: uint256, freeFunds: uint256) -> uint256:\n', '    """\n', '    @notice Calculate amount of ETH to withdraw\n', '    @param shares Amount of uToken shares to burn\n', '    @param totalSupply Total amount of shares before burn\n', '    @param freeFunds Free funds\n', '    @dev Returns amount of ETH to withdraw\n', '    @dev Calculated with `freeFunds`, not `totalAssets`\n', '    """\n', '    # s = shares\n', '    # T = total supply of shares\n', '    # a = amount to withdraw\n', '    # P = total amount of ETH in vault + fund manager\n', '    # s / T = a / P (constraints T >= s, P >= a)\n', '    # sP = aT\n', '    # s = 0               | a = 0\n', '    # s > 0, T = 0, P = 0 | invalid (violates constraint T >= s)\n', '    # s > 0, T = 0, P > 0 | invalid (violates constraint T >= s)\n', '    # s > 0, T > 0, P = 0 | a = 0\n', '    # s > 0, T > 0, P > 0 | a = sP / T\n', '    if shares == 0:\n', '        return 0\n', '    # invalid if total supply = 0\n', '    return shares * freeFunds / totalSupply\n', '\n', '\n', '@external\n', '@view\n', 'def calcWithdraw(shares: uint256) -> uint256:\n', '    return self._calcWithdraw(shares, self.uToken.totalSupply(), self._calcFreeFunds())\n', '\n', '\n', '@external\n', '@payable\n', '@nonreentrant("lock")\n', 'def deposit(amount: uint256, _min: uint256) -> uint256:\n', '    """\n', '    @notice Deposit ETH into vault\n', '    @param amount Amount of ETH to deposit\n', '    @param _min Minimum amount of uToken to be minted\n', '    @dev Returns actual amount of uToken minted\n', '    """\n', '    assert self.initialized, "!initialized"\n', '    assert not self.paused, "paused"\n', '    # check block delay or whitelisted\n', '    assert (\n', '        block.number >= self.uToken.lastBlock(msg.sender) + self.blockDelay\n', '        or self.whitelist[msg.sender]\n', '    ), "block < delay"\n', '\n', '    assert amount == msg.value, "amount != msg.value"\n', '    assert amount > 0, "deposit = 0"\n', '\n', '    # check deposit limit\n', '    assert self._totalAssets() + amount <= self.depositLimit, "deposit limit"\n', '\n', '    # calculate with free funds before deposit (msg.value is not included in freeFunds)\n', '    shares: uint256 = self._calcSharesToMint(\n', '        amount, self.uToken.totalSupply(), self._calcFreeFunds()\n', '    )\n', '    assert shares >= _min, "shares < min"\n', '\n', '    self.balanceOfVault += amount\n', '    self.uToken.mint(msg.sender, shares)\n', '\n', '    # check ETH balance >= balanceOfVault\n', '    assert self.balance >= self.balanceOfVault, "bal < vault"\n', '\n', '    log Deposit(msg.sender, amount, shares)\n', '\n', '    return shares\n', '\n', '\n', '@external\n', '@nonreentrant("lock")\n', 'def withdraw(shares: uint256, _min: uint256) -> uint256:\n', '    """\n', '    @notice Withdraw ETH from vault\n', '    @param shares Amount of uToken to burn\n', '    @param _min Minimum amount of ETH that msg.sender will receive\n', '    @dev Returns actual amount of ETH transferred to msg.sender\n', '    """\n', '    assert self.initialized, "!initialized"\n', '    # check block delay or whitelisted\n', '    assert (\n', '        block.number >= self.uToken.lastBlock(msg.sender) + self.blockDelay\n', '        or self.whitelist[msg.sender]\n', '    ), "block < delay"\n', '\n', '    _shares: uint256 = min(shares, self.uToken.balanceOf(msg.sender))\n', '    assert _shares > 0, "shares = 0"\n', '\n', '    amount: uint256 = self._calcWithdraw(\n', '        _shares, self.uToken.totalSupply(), self._calcFreeFunds()\n', '    )\n', '\n', '    # withdraw from fund manager if amount to withdraw > balance of vault\n', '    if amount > self.balanceOfVault:\n', '        diff: uint256 = self.balance\n', '        # loss = debt - total assets in fund manager + any loss from strategies\n', '        # ETH received by __default__\n', '        loss: uint256 = self.fundManager.withdraw(amount - self.balanceOfVault)\n', '        diff = self.balance - diff\n', '\n', '        # diff + loss may be >= amount\n', '        if loss > 0:\n', '            # msg.sender must cover all of loss\n', '            amount -= loss\n', '            self.debt -= loss\n', '\n', '        self.debt -= diff\n', '        self.balanceOfVault += diff\n', '\n', '        if amount > self.balanceOfVault:\n', '            amount = self.balanceOfVault\n', '\n', '    self.uToken.burn(msg.sender, _shares)\n', '\n', '    assert amount >= _min, "amount < min"\n', '    self.balanceOfVault -= amount\n', '\n', '    self._sendEth(msg.sender, amount)\n', '\n', '    # check ETH balance >= balanceOfVault\n', '    assert self.balance >= self.balanceOfVault, "bal < vault"\n', '\n', '    log Withdraw(msg.sender, _shares, amount)\n', '\n', '    return amount\n', '\n', '\n', '@internal\n', '@view\n', 'def _calcMinReserve() -> uint256:\n', '    """\n', '    @notice Calculate minimum amount of ETH that is reserved in vault for\n', '            cheap withdraw by users\n', '    @dev Returns min reserve\n', '    """\n', '    freeFunds: uint256 = self._calcFreeFunds()\n', '    return freeFunds * self.minReserve / MAX_MIN_RESERVE\n', '\n', '\n', '@external\n', 'def calcMinReserve() -> uint256:\n', '    return self._calcMinReserve()\n', '\n', '\n', '@internal\n', '@view\n', 'def _calcMaxBorrow() -> uint256:\n', '    """\n', '    @notice Calculate amount of ETH available for fund manager to borrow\n', '    @dev Returns amount of ETH fund manager can borrow\n', '    """\n', '    if (\n', '        (not self.initialized)\n', '        or self.paused\n', '        or self.fundManager.address == ZERO_ADDRESS\n', '    ):\n', '        return 0\n', '\n', '    minBal: uint256 = self._calcMinReserve()\n', '\n', '    if self.balanceOfVault > minBal:\n', '        return self.balanceOfVault - minBal\n', '    return 0\n', '\n', '\n', '@external\n', '@view\n', 'def calcMaxBorrow() -> uint256:\n', '    return self._calcMaxBorrow()\n', '\n', '\n', '@external\n', 'def borrow(amount: uint256) -> uint256:\n', '    """\n', '    @notice Borrow ETH from vault\n', '    @dev Only fund manager can borrow\n', '    @dev Returns actual amount that was given to fund manager\n', '    """\n', '    assert self.initialized, "!initialized"\n', '    assert not self.paused, "paused"\n', '    assert msg.sender == self.fundManager.address, "!fund manager"\n', '\n', '    available: uint256 = self._calcMaxBorrow()\n', '    _amount: uint256 = min(amount, available)\n', '    assert _amount > 0, "borrow = 0"\n', '\n', '    self._sendEth(msg.sender, _amount)\n', '\n', '    self.balanceOfVault -= _amount\n', '    self.debt += _amount\n', '\n', '    # check ETH balance >= balanceOfVault\n', '    assert self.balance >= self.balanceOfVault, "bal < vault"\n', '\n', '    log Borrow(msg.sender, amount, _amount)\n', '\n', '    return _amount\n', '\n', '\n', '@external\n', '@payable\n', 'def repay(amount: uint256) -> uint256:\n', '    """\n', '    @notice Repay ETH to vault\n', '    @dev Only fund manager can borrow\n', '    @dev Returns actual amount that was repaid by fund manager\n', '    """\n', '    assert self.initialized, "!initialized"\n', '    assert msg.sender == self.fundManager.address, "!fund manager"\n', '\n', '    assert amount == msg.value, "amount != msg.value"\n', '    assert amount > 0, "repay = 0"\n', '\n', '    self.balanceOfVault += amount\n', '    self.debt -= amount\n', '\n', '    # check ETH balance >= balanceOfVault\n', '    assert self.balance >= self.balanceOfVault, "bal < vault"\n', '\n', '    log Repay(msg.sender, amount, amount)\n', '\n', '    return amount\n', '\n', '\n', '@external\n', '@payable\n', 'def report(gain: uint256, loss: uint256):\n', '    """\n', '    @notice Report profit or loss\n', '    @param gain Profit since last report\n', '    @param loss Loss since last report\n', '    @dev Only fund manager can call\n', '    @dev Locks profit to be release over time\n', '    """\n', '    assert self.initialized, "!initialized"\n', '    assert msg.sender == self.fundManager.address, "!fund manager"\n', "    # can't have both gain and loss > 0\n", '    assert (gain >= 0 and loss == 0) or (gain == 0 and loss >= 0), "gain and loss > 0"\n', '    assert gain == msg.value, "gain != msg.value"\n', '\n', '    # calculate current locked profit\n', '    lockedProfit: uint256 = self._calcLockedProfit()\n', '    diff: uint256 = msg.value  # actual amount transferred if gain > 0\n', '\n', '    if gain > 0:\n', '        # free funds = bal + diff + debt - (locked profit + diff)\n', '        self.balanceOfVault += diff\n', '        self.lockedProfit = lockedProfit + diff\n', '    elif loss > 0:\n', '        # free funds = bal + debt - loss - (locked profit - loss)\n', '        self.debt -= loss\n', '        # deduct locked profit\n', '        if lockedProfit > loss:\n', '            self.lockedProfit -= loss\n', '        else:\n', '            # no locked profit to be released\n', '            self.lockedProfit = 0\n', '\n', '    self.lastReport = block.timestamp\n', '\n', '    # check ETH balance >= balanceOfVault\n', '    assert self.balance >= self.balanceOfVault, "bal < vault"\n', '\n', '    # log updated debt and lockedProfit\n', '    log Report(\n', '        msg.sender, self.balanceOfVault, self.debt, gain, loss, diff, self.lockedProfit\n', '    )\n', '\n', '\n', '@external\n', 'def forceUpdateBalanceOfVault():\n', '    """\n', '    @notice Force `balanceOfVault` to equal `self.balance`\n', '    @dev Only use in case of emergency if `balanceOfVault` is > actual balance\n', '    """\n', '    assert self.initialized, "!initialized"\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '\n', '    bal: uint256 = self.balance\n', '    assert bal < self.balanceOfVault, "bal >= vault"\n', '\n', '    self.balanceOfVault = bal\n', '    log ForceUpdateBalanceOfVault(bal)\n', '\n', '\n', '@external\n', 'def skim():\n', '    """\n', '    @notice Transfer excess ETH sent to this contract to admin or time lock\n', '    @dev actual ETH balance must be >= `balanceOfVault`\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    self._sendEth(msg.sender, self.balance - self.balanceOfVault)\n', '\n', '\n', '@external\n', 'def sweep(token: address):\n', '    """\n', '    @notice Transfer any token accidentally sent to this contract\n', '            to admin or time lock\n', '    """\n', '    assert msg.sender in [self.timeLock, self.admin], "!auth"\n', '    self._safeTransfer(token, msg.sender, ERC20(token).balanceOf(self))']