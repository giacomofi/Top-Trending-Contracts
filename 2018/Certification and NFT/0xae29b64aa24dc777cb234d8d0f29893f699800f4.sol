['pragma solidity 0.4.20;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '  \n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    Pause();\n', '  }\n', '\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    Unpause();\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', ' \n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    assert(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '    assert(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    assert(token.approve(spender, value));\n', '  }\n', '}\n', '\n', 'contract CanReclaimToken is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  function reclaimToken(ERC20Basic token) external onlyOwner {\n', '    uint256 balance = token.balanceOf(this);\n', '    token.safeTransfer(owner, balance);\n', '  }\n', '\n', '}\n', '\n', 'contract JackpotAccessControl is Claimable, Pausable, CanReclaimToken {\n', '    address public cfoAddress;\n', '    \n', '    function JackpotAccessControl() public {\n', '        cfoAddress = msg.sender;\n', '    }\n', '    \n', '    modifier onlyCFO() {\n', '        require(msg.sender == cfoAddress);\n', '        _;\n', '    }\n', '\n', '    function setCFO(address _newCFO) external onlyOwner {\n', '        require(_newCFO != address(0));\n', '\n', '        cfoAddress = _newCFO;\n', '    }\n', '}\n', '\n', 'contract JackpotBase is JackpotAccessControl {\n', '    using SafeMath for uint256;\n', ' \n', '    bool public gameStarted;\n', '    \n', '    address public gameStarter;\n', '    address public lastPlayer;\n', '\taddress public player2;\n', '\taddress public player3;\n', '\taddress public player4;\n', '\taddress public player5;\n', '\t\n', '    uint256 public lastWagerTimeoutTimestamp;\n', '\tuint256 public player2Timestamp;\n', '\tuint256 public player3Timestamp;\n', '\tuint256 public player4Timestamp;\n', '\tuint256 public player5Timestamp;\n', '\t\n', '    uint256 public timeout;\n', '    uint256 public nextTimeout;\n', '    uint256 public minimumTimeout;\n', '    uint256 public nextMinimumTimeout;\n', '    uint256 public numberOfWagersToMinimumTimeout;\n', '    uint256 public nextNumberOfWagersToMinimumTimeout;\n', '\t\n', '\tuint256 currentTimeout;\n', '\t\n', '    uint256 public wagerIndex = 0;\n', '    \n', '\tuint256 public currentBalance;\n', '\t\n', '    function calculateTimeout() public view returns(uint256) {\n', '        if (wagerIndex >= numberOfWagersToMinimumTimeout || numberOfWagersToMinimumTimeout == 0) {\n', '            return minimumTimeout;\n', '        } else {\n', '            uint256 difference = timeout - minimumTimeout;\n', '            \n', '            uint256 decrease = difference.mul(wagerIndex).div(numberOfWagersToMinimumTimeout);\n', '                   \n', '            return (timeout - decrease);\n', '        }\n', '    }\n', '}\n', '\n', 'contract PullPayment {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) public payments;\n', '  uint256 public totalPayments;\n', '\n', '  function withdrawPayments() public {\n', '    address payee = msg.sender;\n', '    uint256 payment = payments[payee];\n', '\n', '    require(payment != 0);\n', '    require(this.balance >= payment);\n', '\t\n', '    totalPayments = totalPayments.sub(payment);\n', '    payments[payee] = 0;\n', '\n', '    assert(payee.send(payment));\n', '  }\n', '\n', '  function asyncSend(address dest, uint256 amount) internal {\n', '    payments[dest] = payments[dest].add(amount);\n', '    totalPayments = totalPayments.add(amount);\n', '  }\n', '}\n', '\n', 'contract JackpotFinance is JackpotBase, PullPayment {\n', '    uint256 public feePercentage = 2500;\n', '    \n', '    uint256 public gameStarterDividendPercentage = 2500;\n', '    \n', '    uint256 public price;\n', '    \n', '    uint256 public nextPrice;\n', '    \n', '    uint256 public prizePool;\n', '    \n', '    // The current 5th wager pool (in wei).\n', '    uint256 public wagerPool5;\n', '\t\n', '\t// The current 13th wager pool (in wei).\n', '\tuint256 public wagerPool13;\n', '    \n', '    function setGameStarterDividendPercentage(uint256 _gameStarterDividendPercentage) external onlyCFO {\n', '        require(_gameStarterDividendPercentage <= 4000);\n', '        \n', '        gameStarterDividendPercentage = _gameStarterDividendPercentage;\n', '    }\n', '    \n', '    function _sendFunds(address beneficiary, uint256 amount) internal {\n', '        if (!beneficiary.send(amount)) {\n', '            asyncSend(beneficiary, amount);\n', '        }\n', '    }\n', '    \n', '    function withdrawFreeBalance() external onlyCFO {\n', '\t\t\n', '        uint256 freeBalance = this.balance.sub(totalPayments).sub(prizePool).sub(wagerPool5).sub(wagerPool13);\n', '        \n', '        cfoAddress.transfer(freeBalance);\n', '\t\tcurrentBalance = this.balance;\n', '    }\n', '}\n', '\n', 'contract JackpotCore is JackpotFinance {\n', '    \n', '    function JackpotCore(uint256 _price, uint256 _timeout, uint256 _minimumTimeout, uint256 _numberOfWagersToMinimumTimeout) public {\n', '        require(_timeout >= _minimumTimeout);\n', '        \n', '        nextPrice = _price;\n', '        nextTimeout = _timeout;\n', '        nextMinimumTimeout = _minimumTimeout;\n', '        nextNumberOfWagersToMinimumTimeout = _numberOfWagersToMinimumTimeout;\n', '        //NextGame(nextPrice, nextTimeout, nextMinimumTimeout, nextNumberOfWagersToMinimumTimeout);\n', '    }\n', '    \n', '    //event NextGame(uint256 price, uint256 timeout, uint256 minimumTimeout, uint256 numberOfWagersToMinimumTimeout);\n', '    event Start(address indexed starter, uint256 timestamp, uint256 price, uint256 timeout, uint256 minimumTimeout, uint256 numberOfWagersToMinimumTimeout);\n', '    event End(address indexed winner, uint256 timestamp, uint256 prize);\n', '    event Bet(address player, uint256 timestamp, uint256 timeoutTimestamp, uint256 wagerIndex, uint256 newPrizePool);\n', '    event TopUpPrizePool(address indexed donater, uint256 ethAdded, string message, uint256 newPrizePool);\n', '    \n', '    function bet(bool startNewGameIfIdle) external payable {\n', '\t\trequire(msg.value >= price);\n', '\t\t\n', '        _processGameEnd();\n', '\t\t\n', '        if (!gameStarted) {\n', '            require(!paused);\n', '\n', '            require(startNewGameIfIdle);\n', '            \n', '            price = nextPrice;\n', '            timeout = nextTimeout;\n', '            minimumTimeout = nextMinimumTimeout;\n', '            numberOfWagersToMinimumTimeout = nextNumberOfWagersToMinimumTimeout;\n', '            \n', '            gameStarted = true;\n', '            \n', '            gameStarter = msg.sender;\n', '            \n', '            Start(msg.sender, now, price, timeout, minimumTimeout, numberOfWagersToMinimumTimeout);\n', '        }\n', '        \n', '        // Calculate the fees and dividends.\n', '        uint256 fee = price.mul(feePercentage).div(100000);\n', '        uint256 dividend = price.mul(gameStarterDividendPercentage).div(100000);\n', '\t\t\n', '        uint256 wagerPool5Part;\n', '\t\tuint256 wagerPool13Part;\n', '        \n', '\t\t// Calculate the wager pool part.\n', '        wagerPool5Part = price.mul(2).div(10);\n', '\t\twagerPool13Part = price.mul(3).div(26);\n', '            \n', '        // Add funds to the wager pool.\n', '        wagerPool5 = wagerPool5.add(wagerPool5Part);\n', '\t\twagerPool13 = wagerPool13.add(wagerPool13Part);\n', '\t\t\n', '\t\tprizePool = prizePool.add(price);\n', '\t\tprizePool = prizePool.sub(fee);\n', '\t\tprizePool = prizePool.sub(dividend);\n', '\t\tprizePool = prizePool.sub(wagerPool5Part);\n', '\t\tprizePool = prizePool.sub(wagerPool13Part);\n', '\t\t\n', '\t\tif (wagerIndex % 5 == 4) {\n', '            // On every 5th wager, give 2x back\n', '\t\t\t\n', '            uint256 wagerPrize5 = price.mul(2);\n', '            \n', '            // Calculate the missing wager pool part, remove earlier added wagerPool5Part\n', '            uint256 difference5 = wagerPrize5.sub(wagerPool5);\n', '\t\t\tprizePool = prizePool.sub(difference5);\n', '        \n', '            msg.sender.transfer(wagerPrize5);\n', '            \n', '            wagerPool5 = 0;\n', '        }\n', '\t\t\n', '\t\tif (wagerIndex % 13 == 12) {\n', '\t\t\t// On every 13th wager, give 3x back\n', '\t\t\t\n', '\t\t\tuint256 wagerPrize13 = price.mul(3);\n', '\t\t\t\n', '\t\t\tuint256 difference13 = wagerPrize13.sub(wagerPool13);\n', '\t\t\tprizePool = prizePool.sub(difference13);\n', '\t\t\t\n', '\t\t\tmsg.sender.transfer(wagerPrize13);\n', '\t\t\t\n', '\t\t\twagerPool13 = 0;\n', '\t\t}\n', '\n', '\t\tplayer5 = player4;\n', '\t\tplayer4 = player3;\n', '\t\tplayer3 = player2;\n', '\t\tplayer2 = lastPlayer;\n', '\t\t\n', '\t\tplayer5Timestamp = player4Timestamp;\n', '\t\tplayer4Timestamp = player3Timestamp;\n', '\t\tplayer3Timestamp = player2Timestamp;\n', '\t\t\n', '\t\tif (lastWagerTimeoutTimestamp > currentTimeout) {\n', '\t\t\tplayer2Timestamp = lastWagerTimeoutTimestamp.sub(currentTimeout);\n', '\t\t}\n', '\t\t\n', '\t\tcurrentTimeout = calculateTimeout();\n', '\t\t\n', '        lastPlayer = msg.sender;\n', '        lastWagerTimeoutTimestamp = now + currentTimeout;\n', '        \n', '\t\twagerIndex = wagerIndex.add(1);\n', '\t\t\n', '        Bet(msg.sender, now, lastWagerTimeoutTimestamp, wagerIndex, prizePool);\n', '        \n', '        _sendFunds(gameStarter, dividend);\n', '\t\t//_sendFunds(cfoAddress, fee);\n', '        \n', '        uint256 excess = msg.value - price;\n', '        \n', '        if (excess > 0) {\n', '            msg.sender.transfer(excess);\n', '        }\n', '\t\t\n', '\t\tcurrentBalance = this.balance;\n', '    }\n', '    \n', '    function topUp(string message) external payable {\n', '        require(gameStarted || !paused);\n', '        \n', '        require(msg.value > 0);\n', '        \n', '        prizePool = prizePool.add(msg.value);\n', '        \n', '        TopUpPrizePool(msg.sender, msg.value, message, prizePool);\n', '    }\n', '    \n', '    function setNextGame(uint256 _price, uint256 _timeout, uint256 _minimumTimeout, uint256 _numberOfWagersToMinimumTimeout) external onlyCFO {\n', '        require(_timeout >= _minimumTimeout);\n', '    \n', '        nextPrice = _price;\n', '        nextTimeout = _timeout;\n', '        nextMinimumTimeout = _minimumTimeout;\n', '        nextNumberOfWagersToMinimumTimeout = _numberOfWagersToMinimumTimeout;\n', '        //NextGame(nextPrice, nextTimeout, nextMinimumTimeout, nextNumberOfWagersToMinimumTimeout);\n', '    } \n', '    \n', '    function endGame() external {\n', '        require(_processGameEnd());\n', '    }\n', '    \n', '    function _processGameEnd() internal returns(bool) {\n', '        if (!gameStarted) {\n', '            return false;\n', '        }\n', '    \n', '        if (now <= lastWagerTimeoutTimestamp) {\n', '            return false;\n', '        }\n', '        \n', '\t\t// gameStarted AND past the time limit\n', '        uint256 excessPool = wagerPool5.add(wagerPool13);\n', '        \n', '        _sendFunds(lastPlayer, prizePool);\n', '\t\t_sendFunds(cfoAddress, excessPool);\n', '        \n', '        End(lastPlayer, lastWagerTimeoutTimestamp, prizePool);\n', '        \n', '        gameStarted = false;\n', '        gameStarter = 0x0;\n', '        lastPlayer = 0x0;\n', '\t\tplayer2 = 0x0;\n', '\t\tplayer3 = 0x0;\n', '\t\tplayer4 = 0x0;\n', '\t\tplayer5 = 0x0;\n', '        lastWagerTimeoutTimestamp = 0;\n', '\t\tplayer2Timestamp = 0;\n', '\t\tplayer3Timestamp = 0;\n', '\t\tplayer4Timestamp = 0;\n', '\t\tplayer5Timestamp = 0;\n', '        wagerIndex = 0;\n', '        prizePool = 0;\n', '        wagerPool5 = 0;\n', '\t\twagerPool13 = 0;\n', '\t\tcurrentBalance = this.balance;\n', '        \n', '        return true;\n', '    }\n', '}']