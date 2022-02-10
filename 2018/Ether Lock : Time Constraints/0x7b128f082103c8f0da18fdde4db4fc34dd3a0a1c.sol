['pragma solidity ^0.4.25;\n', ' \n', '/**\n', '*\n', '*  https://fairdapp.com/crash/  https://fairdapp.com/crash/   https://fairdapp.com/crash/\n', '*\n', '*\n', '*        _______     _       ______  _______ ______ ______  \n', '*       (_______)   (_)     (______)(_______|_____ (_____ \\ \n', '*        _____ _____ _  ____ _     _ _______ _____) )____) )\n', '*       |  ___|____ | |/ ___) |   | |  ___  |  ____/  ____/ \n', '*       | |   / ___ | | |   | |__/ /| |   | | |    | |      \n', '*       |_|   \\_____|_|_|   |_____/ |_|   |_|_|    |_|\n', '*       \n', '*        ______       ______     _______                  _     \n', '*       (_____ \\     (_____ \\   (_______)                | |    \n', '*        _____) )   _ _____) )   _        ____ _____  ___| |__  \n', '*       |  ____/ | | |  ____/   | |      / ___|____ |/___)  _ \\ \n', '*       | |     \\ V /| |        | |_____| |   / ___ |___ | | | |\n', '*       |_|      \\_/ |_|         \\______)_|   \\_____(___/|_| |_|\n', '*                                                        \n', '*   \n', '*  Warning: \n', '*\n', '*  This contract is intented for entertainment purpose only.\n', '*  All could be lost by sending anything to this contract address. \n', '*  All users are prohibited to interact with this contract if this \n', '*  contract is in conflict with user’s local regulations or laws.   \n', '*  \n', '*  -Just another unique concept by the FairDAPP community.\n', '*  -The FIRST PvP Crash game ever created!  \n', '*\n', '*/\n', '\n', 'contract FairExchange{\n', '    function balanceOf(address _customerAddress) public view returns(uint256);\n', '    function myTokens() public view returns(uint256);\n', '    function transfer(address _toAddress, uint256 _amountOfTokens) public returns(bool);\n', '}\n', '\n', 'contract PvPCrash {\n', ' \n', '    using SafeMath for uint256;\n', '    \n', '    /**\n', '     * @dev Modifiers\n', '     */\n', ' \n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier gasMin() {\n', '        require(gasleft() >= gasLimit);\n', '        require(tx.gasprice <= gasPriceLimit);\n', '        _;\n', '    }\n', '    \n', '    modifier isHuman() {\n', '        address _customerAddress = msg.sender;\n', '        if (_customerAddress != address(fairExchangeContract)){\n', '            require(_customerAddress == tx.origin);\n', '            _;\n', '        }\n', '    }\n', '    \n', '    event Invest(address investor, uint256 amount);\n', '    event Withdraw(address investor, uint256 amount);\n', '    \n', '    event FairTokenBuy(uint256 indexed ethereum, uint256 indexed tokens);\n', '    event FairTokenTransfer(address indexed userAddress, uint256 indexed tokens, uint256 indexed roundCount);\n', '    event FairTokenFallback(address indexed userAddress, uint256 indexed tokens, bytes indexed data);\n', '\n', ' \n', '    mapping(address => mapping (uint256 => uint256)) public investments;\n', '    mapping(address => mapping (uint256 => uint256)) public joined;\n', '    mapping(address => uint256) public userInputAmount;\n', '    mapping(uint256 => uint256) public roundStartTime;\n', '    mapping(uint256 => uint256) public roundEndTime;\n', '    mapping(uint256 => uint256) public withdrawBlock;\n', '    \n', '    bool public gameOpen;\n', '    bool public roundEnded;\n', '    uint256 public roundCount = 1;\n', '    uint256 public startCoolDown = 5 minutes;\n', '    uint256 public endCoolDown = 5 minutes;\n', '    uint256 public minimum = 10 finney;\n', '    uint256 public maximum = 5 ether;\n', '    uint256 public maxNumBlock = 3;\n', '    uint256 public refundRatio = 50;\n', '    uint256 public gasPriceLimit = 25000000000;\n', '    uint256 public gasLimit = 300000;\n', '    \n', '    address constant public owner = 0xbC817A495f0114755Da5305c5AA84fc5ca7ebaBd;\n', '    \n', '    FairExchange constant private fairExchangeContract = FairExchange(0xdE2b11b71AD892Ac3e47ce99D107788d65fE764e);\n', '\n', '    PvPCrashFormula constant private pvpCrashFormula = PvPCrashFormula(0xe3c518815fE5f1e970F8fC5F2eFFcF2871be5C4d);\n', '    \n', '\n', '    /**\n', '     * @dev Сonstructor Sets the original roles of the contract\n', '     */\n', ' \n', '    constructor() \n', '        public \n', '    {\n', '        roundStartTime[roundCount] = now + startCoolDown;\n', '        gameOpen = true;\n', '    }\n', '    \n', '    function setGameOpen() \n', '        onlyOwner\n', '        public  \n', '    {\n', '        if (gameOpen) {\n', '            require(roundEnded);\n', '            gameOpen = false;\n', '        } else\n', '            gameOpen = true;\n', '    }\n', '    \n', '    function setMinimum(uint256 _minimum) \n', '        onlyOwner\n', '        public  \n', '    {\n', '        require(_minimum < maximum);\n', '        minimum = _minimum;\n', '    }\n', '    \n', '    function setMaximum(uint256 _maximum) \n', '        onlyOwner\n', '        public  \n', '    {\n', '        require(_maximum > minimum);\n', '        maximum = _maximum;\n', '    }\n', '    \n', '    function setRefundRatio(uint256 _refundRatio) \n', '        onlyOwner\n', '        public \n', '    {\n', '        require(_refundRatio <= 100);\n', '        refundRatio = _refundRatio;\n', '    }\n', '    \n', '    function setGasLimit(uint256 _gasLimit) \n', '        onlyOwner\n', '        public \n', '    {\n', '        require(_gasLimit >= 200000);\n', '        gasLimit = _gasLimit;\n', '    }\n', '    \n', '    function setGasPrice(uint256 _gasPrice) \n', '        onlyOwner\n', '        public \n', '    {\n', '        require(_gasPrice >= 1000000000);\n', '        gasPriceLimit = _gasPrice;\n', '    }\n', '    \n', '    function setStartCoolDown(uint256 _coolDown) \n', '        onlyOwner\n', '        public \n', '    {\n', '        require(!gameOpen);\n', '        startCoolDown = _coolDown;\n', '    }\n', '    \n', '    function setEndCoolDown(uint256 _coolDown) \n', '        onlyOwner\n', '        public \n', '    {\n', '        require(!gameOpen);\n', '        endCoolDown = _coolDown;\n', '    }\n', '    \n', '    function setMaxNumBlock(uint256 _maxNumBlock) \n', '        onlyOwner\n', '        public \n', '    {\n', '        require(!gameOpen);\n', '        maxNumBlock = _maxNumBlock;\n', '    }\n', '    \n', '    function transferFairTokens() \n', '        onlyOwner\n', '        public  \n', '    {\n', '        fairExchangeContract.transfer(owner, fairExchangeContract.myTokens());\n', '    }\n', '    \n', '    function tokenFallback(address _from, uint256 _amountOfTokens, bytes _data) \n', '        public \n', '        returns (bool)\n', '    {\n', '        require(msg.sender == address(fairExchangeContract));\n', '        emit FairTokenFallback(_from, _amountOfTokens, _data);\n', '    }\n', ' \n', '    /**\n', '     * @dev Investments\n', '     */\n', '    function ()\n', '        // gameStarted\n', '        isHuman\n', '        payable\n', '        public\n', '    {\n', '        buy();\n', '    }\n', '\n', '    function buy()\n', '        private\n', '    {\n', '        address _user = msg.sender;\n', '        uint256 _amount = msg.value;\n', '        uint256 _roundCount = roundCount;\n', '        uint256 _currentTimestamp = now;\n', '        uint256 _startCoolDown = startCoolDown;\n', '        uint256 _endCoolDown = endCoolDown;\n', '        require(gameOpen);\n', '        require(_amount >= minimum);\n', '        require(_amount <= maximum);\n', '        \n', '        if (roundEnded == true && _currentTimestamp > roundEndTime[_roundCount] + _endCoolDown) {\n', '            roundEnded = false;\n', '            roundCount++;\n', '            _roundCount = roundCount;\n', '            roundStartTime[_roundCount] = _currentTimestamp + _startCoolDown;\n', '            \n', '        } else if (roundEnded) {\n', '            require(_currentTimestamp > roundEndTime[_roundCount] + _endCoolDown);\n', '        }\n', '\n', '        require(investments[_user][_roundCount] == 0);\n', '        if (!roundEnded) {\n', '            if (_currentTimestamp >= roundStartTime[_roundCount].sub(_startCoolDown)\n', '                && _currentTimestamp < roundStartTime[_roundCount]\n', '            ) {\n', '                joined[_user][_roundCount] = roundStartTime[_roundCount];\n', '            }else if(_currentTimestamp >= roundStartTime[_roundCount]){\n', '                joined[_user][_roundCount] = block.timestamp;\n', '            }\n', '            investments[_user][_roundCount] = _amount;\n', '            userInputAmount[_user] = userInputAmount[_user].add(_amount);\n', '            bool _status = address(fairExchangeContract).call.value(_amount / 20).gas(1000000)();\n', '            require(_status);\n', '            emit FairTokenBuy(_amount / 20, myTokens());\n', '            emit Invest(_user, _amount);\n', '        }\n', '        \n', '    }\n', '    \n', '    /**\n', '    * @dev Withdraw dividends from contract\n', '    */\n', '    function withdraw() \n', '        gasMin\n', '        isHuman \n', '        public \n', '        returns (bool) \n', '    {\n', '        address _user = msg.sender;\n', '        uint256 _roundCount = roundCount;\n', '        uint256 _currentTimestamp = now;\n', '        \n', '        require(joined[_user][_roundCount] > 0);\n', '        require(_currentTimestamp >= roundStartTime[_roundCount]);\n', '        if (roundEndTime[_roundCount] > 0)\n', '            require(_currentTimestamp <= roundEndTime[_roundCount] + endCoolDown);\n', '        \n', '        uint256 _userBalance;\n', '        uint256 _balance = address(this).balance;\n', '        uint256 _totalTokens = fairExchangeContract.myTokens();\n', '        uint256 _tokens;\n', '        uint256 _tokensTransferRatio;\n', '        if (!roundEnded && withdrawBlock[block.number] <= maxNumBlock) {\n', '            _userBalance = getBalance(_user);\n', '            joined[_user][_roundCount] = 0;\n', '            withdrawBlock[block.number]++;\n', '            \n', '            if (_balance > _userBalance) {\n', '                if (_userBalance > 0) {\n', '                    _user.transfer(_userBalance);\n', '                    emit Withdraw(_user, _userBalance);\n', '                }\n', '                return true;\n', '            } else {\n', '                if (_userBalance > 0) {\n', '                    _user.transfer(_balance);\n', '                    if (investments[_user][_roundCount].mul(95).div(100) > _balance) {\n', '                        \n', '                        _tokensTransferRatio = investments[_user][_roundCount] / 0.01 ether * 2;\n', '                        _tokensTransferRatio = _tokensTransferRatio > 20000 ? 20000 : _tokensTransferRatio;\n', '                        _tokens = _totalTokens\n', '                            .mul(_tokensTransferRatio) / 100000;\n', '                        fairExchangeContract.transfer(_user, _tokens);\n', '                        emit FairTokenTransfer(_user, _tokens, _roundCount);\n', '                    }\n', '                    roundEnded = true;\n', '                    roundEndTime[_roundCount] = _currentTimestamp;\n', '                    emit Withdraw(_user, _balance);\n', '                }\n', '                return true;\n', '            }\n', '        } else {\n', '            \n', '            if (!roundEnded) {\n', '                _userBalance = investments[_user][_roundCount].mul(refundRatio).div(100);\n', '                if (_balance > _userBalance) {\n', '                    _user.transfer(_userBalance);\n', '                    emit Withdraw(_user, _userBalance);\n', '                } else {\n', '                    _user.transfer(_balance);\n', '                    roundEnded = true;\n', '                    roundEndTime[_roundCount] = _currentTimestamp;\n', '                    emit Withdraw(_user, _balance);\n', '                }\n', '            }\n', '            _tokensTransferRatio = investments[_user][_roundCount] / 0.01 ether * 2;\n', '            _tokensTransferRatio = _tokensTransferRatio > 20000 ? 20000 : _tokensTransferRatio;\n', '            _tokens = _totalTokens\n', '                .mul(_tokensTransferRatio) / 100000;\n', '            fairExchangeContract.transfer(_user, _tokens);\n', '            joined[_user][_roundCount] = 0;\n', '            emit FairTokenTransfer(_user, _tokens, _roundCount);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '    * @dev Evaluate current balance\n', '    * @param _address Address of player\n', '    */\n', '    function getBalance(address _address) \n', '        view \n', '        public \n', '        returns (uint256) \n', '    {\n', '        uint256 _roundCount = roundCount;\n', '        return pvpCrashFormula.getBalance(\n', '            roundStartTime[_roundCount], \n', '            joined[_address][_roundCount],\n', '            investments[_address][_roundCount],\n', '            userInputAmount[_address],\n', '            fairExchangeContract.balanceOf(_address)\n', '        );\n', '    }\n', '    \n', '    function getAdditionalRewardRatio(address _address) \n', '        view \n', '        public \n', '        returns (uint256) \n', '    {\n', '        return pvpCrashFormula.getAdditionalRewardRatio(\n', '            userInputAmount[_address],\n', '            fairExchangeContract.balanceOf(_address)\n', '        );\n', '    }\n', '    \n', '    /**\n', '    * @dev Gets balance of the sender address.\n', '    * @return An uint256 representing the amount owned by the msg.sender.\n', '    */\n', '    function checkBalance() \n', '        view\n', '        public  \n', '        returns (uint256) \n', '    {\n', '        return getBalance(msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @dev Gets investments of the specified address.\n', '    * @param _investor The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function checkInvestments(address _investor) \n', '        view\n', '        public  \n', '        returns (uint256) \n', '    {\n', '        return investments[_investor][roundCount];\n', '    }\n', '    \n', '    function getFairTokensBalance(address _address) \n', '        view \n', '        public \n', '        returns (uint256) \n', '    {\n', '        return fairExchangeContract.balanceOf(_address);\n', '    }\n', '    \n', '    function myTokens() \n', '        view \n', '        public \n', '        returns (uint256) \n', '    {\n', '        return fairExchangeContract.myTokens();\n', '    }\n', '    \n', '}\n', '\n', 'interface PvPCrashFormula {\n', '    function getBalance(uint256 _roundStartTime, uint256 _joinedTime, uint256 _amount, uint256 _totalAmount, uint256 _tokens) external view returns(uint256);\n', '    function getAdditionalRewardRatio(uint256 _totalAmount, uint256 _tokens) external view returns(uint256);\n', '}\n', ' \n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', ' \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']