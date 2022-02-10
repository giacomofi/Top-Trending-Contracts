['pragma solidity ^0.4.23;\n', '\n', '/*\n', '* Zethell.\n', '*\n', '* Written June 2018 for Zethr (https://www.zethr.game) by Norsefire.\n', '* Special thanks to oguzhanox and Etherguy for assistance with debugging.\n', '*\n', '*/\n', '\n', 'contract ZTHReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);\n', '}\n', '\n', 'contract ZTHInterface {\n', '    function balanceOf(address who) public view returns (uint);\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '    function approve(address spender, uint tokens) public returns (bool);\n', '}\n', '\n', 'contract Zethell is ZTHReceivingContract {\n', '    using SafeMath for uint;\n', '\n', '    address private owner;\n', '    address private bankroll;\n', '\n', '    // How much of the current token balance is reserved as the house take?\n', '    uint    private houseTake;\n', '    \n', '    // How many tokens are currently being played for? (Remember, this is winner takes all)\n', '    uint    public tokensInPlay;\n', '    \n', '    // The token balance of the entire contract.\n', '    uint    public contractBalance;\n', '    \n', '    // Which address is currently winning?\n', '    address public currentWinner;\n', '\n', '    // What time did the most recent clock reset happen?\n', '    uint    public gameStarted;\n', '    \n', '    // What time will the game end if the clock isn&#39;t reset?\n', '    uint    public gameEnds;\n', '    \n', '    // Is betting allowed? (Administrative function, in the event of unforeseen bugs)\n', '    bool    public gameActive;\n', '\n', '    address private ZTHTKNADDR;\n', '    address private ZTHBANKROLL;\n', '    ZTHInterface private     ZTHTKN;\n', '\n', '    mapping (uint => bool) validTokenBet;\n', '    mapping (uint => uint) tokenToTimer;\n', '\n', '    // Fire an event whenever the clock runs out and a winner is determined.\n', '    event GameEnded(\n', '        address winner,\n', '        uint tokensWon,\n', '        uint timeOfWin\n', '    );\n', '\n', '    // Might as well notify everyone when the house takes its cut out.\n', '    event HouseRetrievedTake(\n', '        uint timeTaken,\n', '        uint tokensWithdrawn\n', '    );\n', '\n', '    // Fire an event whenever someone places a bet.\n', '    event TokensWagered(\n', '        address _wagerer,\n', '        uint _wagered,\n', '        uint _newExpiry\n', '    );\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyBankroll {\n', '        require(msg.sender == bankroll);\n', '        _; \n', '    }\n', '\n', '    modifier onlyOwnerOrBankroll {\n', '        require(msg.sender == owner || msg.sender == bankroll);\n', '        _;\n', '    }\n', '\n', '    constructor(address ZethrAddress, address BankrollAddress) public {\n', '\n', '        // Set Zethr & Bankroll address from constructor params\n', '        ZTHTKNADDR = ZethrAddress;\n', '        ZTHBANKROLL = BankrollAddress;\n', '\n', '        // Set starting variables\n', '        owner         = msg.sender;\n', '        bankroll      = ZTHBANKROLL;\n', '        currentWinner = msg.sender;\n', '\n', '        // Approve "infinite" token transfer to the bankroll, as part of Zethr game requirements.\n', '        ZTHTKN = ZTHInterface(ZTHTKNADDR);\n', '        ZTHTKN.approve(ZTHBANKROLL, 2**256 - 1);\n', '\n', '        // To start with, we only allow bets of 5, 10, 25 or 50 ZTH.\n', '        validTokenBet[1e18]  = true;\n', '        validTokenBet[2e18] = true;\n', '        validTokenBet[5e18] = true;\n', '        validTokenBet[10e18] = true;\n', '\n', '        // Logarithmically decreasing time &#39;bonus&#39; associated with higher amounts of ZTH staked.\n', '        tokenToTimer[1e18]  = 60 minutes;\n', '        tokenToTimer[2e18] = 50 minutes;\n', '        tokenToTimer[5e18] = 30 minutes;\n', '        tokenToTimer[10e18] = 1 minutes;\n', '        \n', '        // Set the initial timers to contract genesis.\n', '        gameStarted = now;\n', '        gameEnds    = gameStarted.add(24 hours);\n', '        gameActive  = true;\n', '    }\n', '    \n', '    // Zethr dividends gained are sent to Bankroll later\n', '    function() public payable {  }\n', '\n', '    // If the contract receives tokens, bundle them up in a struct and fire them over to _stakeTokens for validation.\n', '    struct TKN { address sender; uint value; }\n', '    function tokenFallback(address _from, uint _value, bytes /* _data */) public returns (bool){\n', '        if(_from != ZTHBANKROLL){\n', '           TKN memory          _tkn;\n', '            _tkn.sender       = _from;\n', '            _tkn.value        = _value;\n', '            _stakeTokens(_tkn); \n', '            return true;\n', '        }else{\n', '            contractBalance = contractBalance.add(_value);\n', '            tokensInPlay    = tokensInPlay.add(_value);\n', '        }\n', '    }\n', '\n', '    // First, we check to see if the tokens are ZTH tokens. If not, we revert the transaction.\n', '    // Next - if the game has already ended (i.e. your bet was too late and the clock ran out)\n', '    //   the staked tokens from the previous game are transferred to the winner, the timers are\n', '    //   reset, and the game begins anew.\n', '    // If you&#39;re simply resetting the clock, the timers are reset accordingly and you are designated\n', '    //   the current winner. A 1% cut will be taken for the house, and the rest deposited in the prize\n', '    //   pool which everyone will be playing for. No second place prizes here!\n', '    function _stakeTokens(TKN _tkn) private {\n', '   \n', '        require(gameActive); \n', '        require(_zthToken(msg.sender));\n', '        require(validTokenBet[_tkn.value]);\n', '        \n', '        if (now > gameEnds) { _settleAndRestart(); }\n', '\n', '        address _customerAddress = _tkn.sender;\n', '        uint    _wagered         = _tkn.value;\n', '\n', '        uint rightNow      = now;\n', '        uint timePurchased = tokenToTimer[_tkn.value];\n', '        uint newGameEnd    = gameEnds.add(timePurchased);\n', '        if(newGameEnd.sub(rightNow) > 24 hours){newGameEnd = rightNow.add(24 hours);}\n', '        \n', '        //gameStarted   = rightNow;\n', '        gameEnds      = newGameEnd;\n', '        currentWinner = _customerAddress;\n', '\n', '        contractBalance = contractBalance.add(_wagered);\n', '        uint houseCut   = _wagered.div(100);\n', '        uint toAdd      = _wagered.sub(houseCut);\n', '        houseTake       = houseTake.add(houseCut);\n', '        tokensInPlay    = tokensInPlay.add(toAdd);\n', '\n', '        emit TokensWagered(_customerAddress, _wagered, newGameEnd);\n', '\n', '    }\n', '\n', '    // In the event of a game restart, subtract the tokens which were being played for from the balance,\n', '    //   transfer them to the winner (if the number of tokens is greater than zero: sly edge case).\n', '    // If there is *somehow* any Ether in the contract - again, please don&#39;t - it is transferred to the\n', '    //   bankroll and reinvested into Zethr at the standard 33% rate.\n', '    function _settleAndRestart() private {\n', '        gameActive      = false;\n', '        uint payment = tokensInPlay/2;\n', '        contractBalance = contractBalance.sub(payment);\n', '\n', '        if (tokensInPlay > 0) { ZTHTKN.transfer(currentWinner, payment);\n', '            if (address(this).balance > 0){\n', '                ZTHBANKROLL.transfer(address(this).balance);\n', '            }}\n', '\n', '        emit GameEnded(currentWinner, payment, now);\n', '\n', '        // Reset values.\n', '        tokensInPlay  = tokensInPlay.sub(payment);\n', '        gameActive    = true;\n', '        gameStarted   = now;\n', '        gameEnds      = gameStarted.add(24 hours);\n', '    }\n', '\n', '    // How many tokens are in the contract overall?\n', '    function balanceOf() public view returns (uint) {\n', '        return contractBalance;\n', '    }\n', '\n', '    // Administrative function for adding a new token-time pair, should there be demand.\n', '    function addTokenTime(uint _tokenAmount, uint _timeBought) public onlyOwner {\n', '        validTokenBet[_tokenAmount] = true;\n', '        tokenToTimer[_tokenAmount]  = _timeBought;\n', '    }\n', '\n', '    // Administrative function to REMOVE a token-time pair, should one fall out of use. \n', '    function removeTokenTime(uint _tokenAmount) public onlyOwner {\n', '        validTokenBet[_tokenAmount] = false;\n', '        tokenToTimer[_tokenAmount]  = 232 days;\n', '    }\n', '\n', '    // Function to pull out the house cut to the bankroll if required (i.e. to seed other games).\n', '    function retrieveHouseTake() public onlyOwnerOrBankroll {\n', '        uint toTake = houseTake;\n', '        houseTake = 0;\n', '        contractBalance = contractBalance.sub(toTake);\n', '        ZTHTKN.transfer(bankroll, toTake);\n', '\n', '        emit HouseRetrievedTake(now, toTake);\n', '    }\n', '    function ownerKill() public onlyOwner {\n', '\n', '        ZTHTKN.transfer(bankroll, ZTHTKN.balanceOf(address(this)));\n', '        selfdestruct(bankroll);\n', '\n', '    }\n', '    // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.\n', '    function pauseGame() public onlyOwner {\n', '        gameActive = false;\n', '    }\n', '\n', '    // The converse of the above, resuming betting if a freeze had been put in place.\n', '    function resumeGame() public onlyOwner {\n', '        gameActive = true;\n', '    }\n', '\n', '    // Administrative function to change the owner of the contract.\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    // Administrative function to change the Zethr bankroll contract, should the need arise.\n', '    function changeBankroll(address _newBankroll) public onlyOwner {\n', '        bankroll = _newBankroll;\n', '    }\n', '\n', '    // Is the address that the token has come from actually ZTH?\n', '    function _zthToken(address _tokenContract) private view returns (bool) {\n', '       return _tokenContract == ZTHTKNADDR;\n', '    }\n', '}\n', '\n', '// And here&#39;s the boring bit.\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}']