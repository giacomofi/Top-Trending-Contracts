['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title StandardToken\n', ' * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol\n', ' * @dev Standard ERC20 token\n', ' */\n', 'contract StandardToken {\n', '    using SafeMath for uint256;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    mapping(address => uint256) internal balances_;\n', '    mapping(address => mapping(address => uint256)) internal allowed_;\n', '\n', '    uint256 internal totalSupply_;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances_[_owner];\n', '    }\n', '\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed_ to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed_[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances_[msg.sender]);\n', '\n', '        balances_[msg.sender] = balances_[msg.sender].sub(_value);\n', '        balances_[_to] = balances_[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances_[_from]);\n', '        require(_value <= allowed_[_from][msg.sender]);\n', '\n', '        balances_[_from] = balances_[_from].sub(_value);\n', '        balances_[_to] = balances_[_to].add(_value);\n', '        allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed_[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title EthTeamContract\n', ' * @dev The team token. One token represents a team. EthTeamContract is also a ERC20 standard token.\n', ' */\n', 'contract EthTeamContract is StandardToken, Ownable {\n', '    event Buy(address indexed token, address indexed from, uint256 value, uint256 weiValue);\n', '    event Sell(address indexed token, address indexed from, uint256 value, uint256 weiValue);\n', '    event BeginGame(address indexed team1, address indexed team2, uint64 gameTime);\n', '    event EndGame(address indexed team1, address indexed team2, uint8 gameResult);\n', '    event ChangeStatus(address indexed team, uint8 status);\n', '\n', '    /**\n', '    * @dev Token price based on ETH\n', '    */\n', '    uint256 public price;\n', '    /**\n', '    * @dev status=0 buyable & sellable, user can buy or sell the token.\n', '    * status=1 not buyable & not sellable, user cannot buy or sell the token.\n', '    */\n', '    uint8 public status;\n', '    /**\n', '    * @dev The game start time. gameTime=0 means game time is not enabled or not started.\n', '    */\n', '    uint64 public gameTime;\n', '    /**\n', '    * @dev If the time is older than FinishTime (usually one month after game).\n', '    * The owner has permission to transfer the balance to the feeOwner.\n', '    * The user can get back the balance using the website after this time.\n', '    */\n', '    uint64 public finishTime;\n', '    /**\n', '    * @dev The fee owner. The fee will send to this address.\n', '    */\n', '    address public feeOwner;\n', '    /**\n', '    * @dev Game opponent, gameOpponent is also a EthTeamContract.\n', '    */\n', '    address public gameOpponent;\n', '\n', '    /**\n', '    * @dev Team name and team symbol will be ERC20 token name and symbol. Token decimals will be 3.\n', '    * Token total supply will be 0. The initial price will be 1 szabo (1000000000000 Wei)\n', '    */\n', '    function EthTeamContract(\n', '        string _teamName, string _teamSymbol, address _gameOpponent, uint64 _gameTime, uint64 _finishTime, address _feeOwner\n', '    ) public {\n', '        name = _teamName;\n', '        symbol = _teamSymbol;\n', '        decimals = 3;\n', '        totalSupply_ = 0;\n', '        price = 1 szabo;\n', '        gameOpponent = _gameOpponent;\n', '        gameTime = _gameTime;\n', '        finishTime = _finishTime;\n', '        feeOwner = _feeOwner;\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Sell Or Transfer the token.\n', '    *\n', '    * Override ERC20 transfer token function. If the _to address is not this EthTeamContract,\n', '    * then call the super transfer function, which will be ERC20 token transfer.\n', '    * Otherwise, the user want to sell the token (EthTeamContract -> ETH).\n', '    * @param _to address The address which you want to transfer/sell to\n', '    * @param _value uint256 the amount of tokens to be transferred/sold\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        if (_to != address(this)) {\n', '            return super.transfer(_to, _value);\n', '        }\n', '        require(_value <= balances_[msg.sender] && status == 0);\n', '        // If gameTime is enabled (larger than 1514764800 (2018-01-01))\n', '        if (gameTime > 1514764800) {\n', '            // We will not allowed to sell after 5 minutes (300 seconds) before game start\n', '            require(gameTime - 300 > block.timestamp);\n', '        }\n', '        balances_[msg.sender] = balances_[msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        uint256 weiAmount = price.mul(_value);\n', '        msg.sender.transfer(weiAmount);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        emit Sell(_to, msg.sender, _value, weiAmount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Buy token using ETH\n', '    * User send ETH to this EthTeamContract, then his token balance will be increased based on price.\n', '    * The total supply will also be increased.\n', '    */\n', '    function() payable public {\n', '        require(status == 0 && price > 0);\n', '        // If gameTime is enabled (larger than 1514764800 (2018-01-01))\n', '        if (gameTime > 1514764800) {\n', '            // We will not allowed to sell after 5 minutes (300 seconds) before game start\n', '            require(gameTime - 300 > block.timestamp);\n', '        }\n', '        uint256 amount = msg.value.div(price);\n', '        balances_[msg.sender] = balances_[msg.sender].add(amount);\n', '        totalSupply_ = totalSupply_.add(amount);\n', '        emit Transfer(address(this), msg.sender, amount);\n', '        emit Buy(address(this), msg.sender, amount, msg.value);\n', '    }\n', '\n', '    /**\n', '    * @dev The the game status.\n', '    *\n', '    * status = 0 buyable & sellable, user can buy or sell the token.\n', '    * status=1 not buyable & not sellable, user cannot buy or sell the token.\n', '    * @param _status The game status.\n', '    */\n', '    function changeStatus(uint8 _status) onlyOwner public {\n', '        require(status != _status);\n', '        status = _status;\n', '        emit ChangeStatus(address(this), _status);\n', '    }\n', '\n', '    /**\n', '    * @dev Finish the game\n', '    *\n', '    * If the time is older than FinishTime (usually one month after game).\n', '    * The owner has permission to transfer the balance to the feeOwner.\n', '    * The user can get back the balance using the website after this time.\n', '    */\n', '    function finish() onlyOwner public {\n', '        require(block.timestamp >= finishTime);\n', '        feeOwner.transfer(address(this).balance);\n', '    }\n', '\n', '    /**\n', '    * @dev Start the game\n', '    *\n', '    * Start a new game. Initialize game opponent, game time and status.\n', '    * @param _gameOpponent The game opponent contract address\n', '    * @param _gameTime The game begin time. optional\n', '    */\n', '    function beginGame(address _gameOpponent, uint64 _gameTime) onlyOwner public {\n', '        require(_gameOpponent != address(0) && _gameOpponent != address(this) && gameOpponent == address(0));\n', '        // 1514764800 = 2018-01-01\n', '        require(_gameTime == 0 || (_gameTime > 1514764800));\n', '        gameOpponent = _gameOpponent;\n', '        gameTime = _gameTime;\n', '        status = 0;\n', '        emit BeginGame(address(this), _gameOpponent, _gameTime);\n', '    }\n', '\n', '    /**\n', '    * @dev End the game with game final result.\n', '    *\n', '    * The function only allow to be called with the lose team or the draw team with large balance.\n', '    * We have this rule because the lose team or draw team will large balance need transfer balance to opposite side.\n', '    * This function will also change status of opposite team by calling transferFundAndEndGame function.\n', '    * So the function only need to be called one time for the home and away team.\n', '    * The new price will be recalculated based on the new balance and total supply.\n', '    *\n', '    * Balance transfer rule:\n', '    * 1. The rose team will transfer all balance to opposite side.\n', '    * 2. If the game is draw, the balances of two team will go fifty-fifty.\n', '    * 3. If game is canceled, the balance is not touched and the game states will be reset to initial states.\n', '    * 4. The fee will be 5% of each transfer amount.\n', '    * @param _gameOpponent The game opponent contract address\n', '    * @param _gameResult game result. 1=lose, 2=draw, 3=cancel, 4=win (not allow)\n', '    */\n', '    function endGame(address _gameOpponent, uint8 _gameResult) onlyOwner public {\n', '        require(gameOpponent != address(0) && gameOpponent == _gameOpponent);\n', '        uint256 amount = address(this).balance;\n', '        uint256 opAmount = gameOpponent.balance;\n', '        require(_gameResult == 1 || (_gameResult == 2 && amount >= opAmount) || _gameResult == 3);\n', '        EthTeamContract op = EthTeamContract(gameOpponent);\n', '        if (_gameResult == 1) {\n', '            // Lose\n', '            if (amount > 0 && totalSupply_ > 0) {\n', '                uint256 lostAmount = amount;\n', '                // If opponent has supply\n', '                if (op.totalSupply() > 0) {\n', '                    // fee is 5%\n', '                    uint256 feeAmount = lostAmount.div(20);\n', '                    lostAmount = lostAmount.sub(feeAmount);\n', '                    feeOwner.transfer(feeAmount);\n', '                    op.transferFundAndEndGame.value(lostAmount)();\n', '                } else {\n', '                    // If opponent has not supply, then send the lose money to fee owner.\n', '                    feeOwner.transfer(lostAmount);\n', '                    op.transferFundAndEndGame();\n', '                }\n', '            } else {\n', '                op.transferFundAndEndGame();\n', '            }\n', '        } else if (_gameResult == 2) {\n', '            // Draw\n', '            if (amount > opAmount) {\n', '                lostAmount = amount.sub(opAmount).div(2);\n', '                if (op.totalSupply() > 0) {\n', '                    // fee is 5%\n', '                    feeAmount = lostAmount.div(20);\n', '                    lostAmount = lostAmount.sub(feeAmount);\n', '                    feeOwner.transfer(feeAmount);\n', '                    op.transferFundAndEndGame.value(lostAmount)();\n', '                } else {\n', '                    feeOwner.transfer(lostAmount);\n', '                    op.transferFundAndEndGame();\n', '                }\n', '            } else if (amount == opAmount) {\n', '                op.transferFundAndEndGame();\n', '            } else {\n', '                // should not happen\n', '                revert();\n', '            }\n', '        } else if (_gameResult == 3) {\n', '            //canceled\n', '            op.transferFundAndEndGame();\n', '        } else {\n', '            // should not happen\n', '            revert();\n', '        }\n', '        endGameInternal();\n', '        if (totalSupply_ > 0) {\n', '            price = address(this).balance.div(totalSupply_);\n', '        }\n', '        emit EndGame(address(this), _gameOpponent, _gameResult);\n', '    }\n', '\n', '    /**\n', '    * @dev Reset team token states\n', '    *\n', '    */\n', '    function endGameInternal() private {\n', '        gameOpponent = address(0);\n', '        gameTime = 0;\n', '        status = 0;\n', '    }\n', '\n', '    /**\n', '    * @dev Reset team states and recalculate the price.\n', '    *\n', '    * This function will be called by opponent team token after end game.\n', '    * It accepts the ETH transfer and recalculate the new price based on\n', '    * new balance and total supply.\n', '    */\n', '    function transferFundAndEndGame() payable public {\n', '        require(gameOpponent != address(0) && gameOpponent == msg.sender);\n', '        if (msg.value > 0 && totalSupply_ > 0) {\n', '            price = address(this).balance.div(totalSupply_);\n', '        }\n', '        endGameInternal();\n', '    }\n', '}']