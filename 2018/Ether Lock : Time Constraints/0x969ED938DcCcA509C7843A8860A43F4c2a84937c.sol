['pragma solidity ^0.4.8;\n', '\n', '// @address 0x\n', '// @multisig\n', '// The implementation for the IME.IME ICO smart contract was inspired by\n', '// the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.\n', '// compiler: 0.4.17+commit.bdeb9e52\n', '\n', '/*\n', '1. Contract Address: 0x\n', '\n', '2. Official Site URL:https://www.IME.IM/\n', '\n', '3. Link to download a 28x28png icon logo:https://IME.IM/TOKENLOGO.png\n', '\n', '4. Official Contact Email Address:IM@IME.IM\n', '\n', '5. Link to blog (optional):\n', '\n', '6. Link to reddit (optional):\n', '\n', '7. Link to slack (optional):https://\n', '\n', '8. Link to facebook (optional):https://www.facebook.com/\n', '\n', '9. Link to twitter (optional):@\n', '\n', '10. Link to bitcointalk (optional):\n', '\n', '11. Link to github (optional):https://github.com/IMEIM\n', '\n', '12. Link to telegram (optional):https://t.me/\n', '\n', '13. Link to whitepaper (optional):https://hitepaper_EN.pdf\n', '*/\n', '\n', '///////////////\n', '// SAFE MATH //\n', '///////////////\n', '\n', 'contract SafeMath {\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        require((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        require(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        require((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', '\n', '////////////////////\n', '// STANDARD TOKEN //\n', '////////////////////\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    mapping (address => uint256) balances;\n', '    //pre ico locked balance\n', '    mapping (address => uint256) lockedBalances;\n', '    mapping (address => uint256) initLockedBalances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    bool allowTransfer = false;\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success){\n', '        if (balances[msg.sender] >= _value && _value > 0 && allowTransfer) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && allowTransfer) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance){\n', '        return balances[_owner] + lockedBalances[_owner];\n', '    }\n', '    function availableBalanceOf(address _owner) constant public returns (uint256 balance){\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success){\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '/////////////////////\n', '//IME.IM ICO TOKEN//\n', '/////////////////////\n', '\n', 'contract IMETOKEN is StandardToken, SafeMath {\n', '    // Descriptive properties\n', '    string public constant name = "IME.IM Token";\n', '    string public constant symbol = "IME";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    // Account for ether proceed.\n', '    address public etherProceedsAccount = 0x0;\n', '    address public multiWallet = 0x0;\n', '\n', '    //owners\n', '    mapping (address => bool) public isOwner;\n', '    address[] public owners;\n', '\n', '    // These params specify the start, end, min, and max of the sale.\n', '    bool public isFinalized;\n', '\n', '    uint256 public window0TotalSupply = 0;\n', '    uint256 public window1TotalSupply = 0;\n', '    uint256 public window2TotalSupply = 0;\n', '    uint256 public window3TotalSupply = 0;\n', '\n', '    uint256 public window0StartTime = 0;\n', '    uint256 public window0EndTime = 0;\n', '    uint256 public window1StartTime = 0;\n', '    uint256 public window1EndTime = 0;\n', '    uint256 public window2StartTime = 0;\n', '    uint256 public window2EndTime = 0;\n', '    uint256 public window3StartTime = 0;\n', '    uint256 public window3EndTime = 0;\n', '\n', '    // setting the capacity of every part of ico\n', '    uint256 public preservedTokens = 1300000000 * 10**decimals;\n', '    uint256 public window0TokenCreationCap = 200000000 * 10**decimals;\n', '    uint256 public window1TokenCreationCap = 200000000 * 10**decimals;\n', '    uint256 public window2TokenCreationCap = 300000000 * 10**decimals;\n', '    uint256 public window3TokenCreationCap = 0 * 10**decimals;\n', '\n', '    // Setting the exchange rate for the ICO.\n', '    uint256 public window0TokenExchangeRate = 5000;\n', '    uint256 public window1TokenExchangeRate = 4000;\n', '    uint256 public window2TokenExchangeRate = 3000;\n', '    uint256 public window3TokenExchangeRate = 0;\n', '\n', '    uint256 public preICOLimit = 0;\n', '    bool public instantTransfer = false;\n', '\n', '    // Events for logging refunds and token creation.\n', '    event CreateGameIco(address indexed _to, uint256 _value);\n', '    event PreICOTokenPushed(address indexed _buyer, uint256 _amount);\n', '    event UnlockBalance(address indexed _owner, uint256 _amount);\n', '    event OwnerAddition(address indexed owner);\n', '    event OwnerRemoval(address indexed owner);\n', '\n', '    modifier ownerExists(address owner) {\n', '        require(isOwner[owner]);\n', '        _;\n', '    }\n', '\n', '    // constructor\n', '    function IMEIM() public\n', '    {\n', '        totalSupply             = 2000000000 * 10**decimals;\n', '        isFinalized             = false;\n', '        etherProceedsAccount    = msg.sender;\n', '    }\n', '    function adjustTime(\n', '    uint256 _window0StartTime, uint256 _window0EndTime,\n', '    uint256 _window1StartTime, uint256 _window1EndTime,\n', '    uint256 _window2StartTime, uint256 _window2EndTime)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        window0StartTime = _window0StartTime;\n', '        window0EndTime = _window0EndTime;\n', '        window1StartTime = _window1StartTime;\n', '        window1EndTime = _window1EndTime;\n', '        window2StartTime = _window2StartTime;\n', '        window2EndTime = _window2EndTime;\n', '    }\n', '    function adjustSupply(\n', '    uint256 _window0TotalSupply,\n', '    uint256 _window1TotalSupply,\n', '    uint256 _window2TotalSupply)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        window0TotalSupply = _window0TotalSupply * 10**decimals;\n', '        window1TotalSupply = _window1TotalSupply * 10**decimals;\n', '        window2TotalSupply = _window2TotalSupply * 10**decimals;\n', '    }\n', '    function adjustCap(\n', '    uint256 _preservedTokens,\n', '    uint256 _window0TokenCreationCap,\n', '    uint256 _window1TokenCreationCap,\n', '    uint256 _window2TokenCreationCap)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        preservedTokens = _preservedTokens * 10**decimals;\n', '        window0TokenCreationCap = _window0TokenCreationCap * 10**decimals;\n', '        window1TokenCreationCap = _window1TokenCreationCap * 10**decimals;\n', '        window2TokenCreationCap = _window2TokenCreationCap * 10**decimals;\n', '    }\n', '    function adjustRate(\n', '    uint256 _window0TokenExchangeRate,\n', '    uint256 _window1TokenExchangeRate,\n', '    uint256 _window2TokenExchangeRate)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        window0TokenExchangeRate = _window0TokenExchangeRate;\n', '        window1TokenExchangeRate = _window1TokenExchangeRate;\n', '        window2TokenExchangeRate = _window2TokenExchangeRate;\n', '    }\n', '    function setProceedsAccount(address _newEtherProceedsAccount)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        etherProceedsAccount = _newEtherProceedsAccount;\n', '    }\n', '    function setMultiWallet(address _newWallet)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        multiWallet = _newWallet;\n', '    }\n', '    function setPreICOLimit(uint256 _preICOLimit)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        preICOLimit = _preICOLimit;\n', '    }\n', '    function setInstantTransfer(bool _instantTransfer)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        instantTransfer = _instantTransfer;\n', '    }\n', '    function setAllowTransfer(bool _allowTransfer)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        allowTransfer = _allowTransfer;\n', '    }\n', '    function addOwner(address owner)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        isOwner[owner] = true;\n', '        owners.push(owner);\n', '        OwnerAddition(owner);\n', '    }\n', '    function removeOwner(address owner)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        isOwner[owner] = false;\n', '        OwnerRemoval(owner);\n', '    }\n', '\n', '    function preICOPush(address buyer, uint256 amount)\n', '    public{\n', '        require(msg.sender == etherProceedsAccount);\n', '\n', '        uint256 tokens = 0;\n', '        uint256 checkedSupply = 0;\n', '        checkedSupply = safeAdd(window0TotalSupply, amount);\n', '        require(window0TokenCreationCap >= checkedSupply);\n', '        assignLockedBalance(buyer, amount);\n', '        window0TotalSupply = checkedSupply;\n', '        PreICOTokenPushed(buyer, amount);\n', '    }\n', '    function lockedBalanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return lockedBalances[_owner];\n', '    }\n', '    function initLockedBalanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return initLockedBalances[_owner];\n', '    }\n', '    function unlockBalance(address _owner, uint256 prob)\n', '    public\n', '    ownerExists(msg.sender)\n', '    returns (bool){\n', '        uint256 shouldUnlockedBalance = 0;\n', '        shouldUnlockedBalance = initLockedBalances[_owner] * prob / 100;\n', '        if(shouldUnlockedBalance > lockedBalances[_owner]){\n', '            shouldUnlockedBalance = lockedBalances[_owner];\n', '        }\n', '        balances[_owner] += shouldUnlockedBalance;\n', '        lockedBalances[_owner] -= shouldUnlockedBalance;\n', '        UnlockBalance(_owner, shouldUnlockedBalance);\n', '        return true;\n', '    }\n', '\n', '    function () payable public{\n', '        create();\n', '    }\n', '    function create() internal{\n', '        require(!isFinalized);\n', '        require(msg.value >= 0.01 ether);\n', '        uint256 tokens = 0;\n', '        uint256 checkedSupply = 0;\n', '\n', '        if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){\n', '            if(preICOLimit > 0){\n', '                require(msg.value >= preICOLimit);\n', '            }\n', '            tokens = safeMult(msg.value, window0TokenExchangeRate);\n', '            checkedSupply = safeAdd(window0TotalSupply, tokens);\n', '            require(window0TokenCreationCap >= checkedSupply);\n', '            assignLockedBalance(msg.sender, tokens);\n', '            window0TotalSupply = checkedSupply;\n', '            if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);\n', '            CreateGameIco(msg.sender, tokens);\n', '        }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){\n', '            tokens = safeMult(msg.value, window1TokenExchangeRate);\n', '            checkedSupply = safeAdd(window1TotalSupply, tokens);\n', '            require(window1TokenCreationCap >= checkedSupply);\n', '            balances[msg.sender] += tokens;\n', '            window1TotalSupply = checkedSupply;\n', '            if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);\n', '            CreateGameIco(msg.sender, tokens);\n', '        }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){\n', '            tokens = safeMult(msg.value, window2TokenExchangeRate);\n', '            checkedSupply = safeAdd(window2TotalSupply, tokens);\n', '            require(window2TokenCreationCap >= checkedSupply);\n', '            balances[msg.sender] += tokens;\n', '            window2TotalSupply = checkedSupply;\n', '            if(multiWallet != 0x0 && instantTransfer) multiWallet.transfer(msg.value);\n', '            CreateGameIco(msg.sender, tokens);\n', '        }else{\n', '            require(false);\n', '        }\n', '\n', '    }\n', '\n', '    function time() internal returns (uint) {\n', '        return block.timestamp;\n', '    }\n', '\n', '    function today(uint startTime) internal returns (uint) {\n', '        return dayFor(time(), startTime);\n', '    }\n', '\n', '    function dayFor(uint timestamp, uint startTime) internal returns (uint) {\n', '        return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;\n', '    }\n', '\n', '    function withDraw(uint256 _value) public{\n', '        require(msg.sender == etherProceedsAccount);\n', '        if(multiWallet != 0x0){\n', '            multiWallet.transfer(_value);\n', '        }else{\n', '            etherProceedsAccount.transfer(_value);\n', '        }\n', '    }\n', '\n', '    function finalize() public{\n', '        require(!isFinalized);\n', '        require(msg.sender == etherProceedsAccount);\n', '        isFinalized = true;\n', '        if(multiWallet != 0x0){\n', '            assignLockedBalance(multiWallet, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);\n', '            if(this.balance > 0) multiWallet.transfer(this.balance);\n', '        }else{\n', '            assignLockedBalance(etherProceedsAccount, totalSupply- window0TotalSupply- window1TotalSupply - window2TotalSupply);\n', '            if(this.balance > 0) etherProceedsAccount.transfer(this.balance);\n', '        }\n', '    }\n', '\n', '    function supply() constant public returns (uint256){\n', '        return window0TotalSupply + window1TotalSupply + window2TotalSupply;\n', '    }\n', '\n', '    function assignLockedBalance(address _owner, uint256 val) private{\n', '        initLockedBalances[_owner] += val;\n', '        lockedBalances[_owner] += val;\n', '    }\n', '\n', '}']