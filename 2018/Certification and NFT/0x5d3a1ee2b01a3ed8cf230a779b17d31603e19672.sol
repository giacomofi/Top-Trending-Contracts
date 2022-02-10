['pragma solidity ^0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c4a0a5b2a184a5afaba9a6a5eaa7aba9">[email&#160;protected]</a>\n', '// released under Apache 2.0 licence\n', '// input  /Users/chae/dev/colorcoin/coin-ver2/color-erc20.sol\n', '// flattened :  Thursday, 10-Jan-19 03:27:25 UTC\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '        // benefit is lost if &#39;b&#39; is also tested.\n', '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        \n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;   \n', '    }\n', '    \n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', ' \n', '    // Get the total token supply\n', '    function totalSupply() public constant returns (uint256);\n', '\n', '    // Get the account balance of another account with address _owner   \n', '    function balanceOf(address who) public view returns (uint256);\n', '    \n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    \n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    // this function is required for some DEX functionality   \n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', ' \n', '    // Triggered when tokens are transferred. \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called. \n', '    event Approval(address indexed owner,address indexed spender,uint256 value);\n', ' \n', '}\n', '\n', '//\n', '// Color Coin v2.0\n', '// \n', 'contract ColorCoin is ERC20 {\n', '\n', '    // Time Lock and Vesting\n', '    struct accountData {\n', '      uint256 init_balance;\n', '      uint256 balance;\n', '      uint256 unlockTime1;\n', '      uint256 unlockTime2;\n', '      uint256 unlockTime3;\n', '      uint256 unlockTime4;\n', '      uint256 unlockTime5;\n', '\n', '      uint256 unlockPercent1;\n', '      uint256 unlockPercent2;\n', '      uint256 unlockPercent3;\n', '      uint256 unlockPercent4;\n', '      uint256 unlockPercent5;\n', '    }\n', '    \n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    \n', '    mapping(address => accountData) private accounts;\n', '    \n', '    mapping(address => bool) private lockedAddresses;\n', '    \n', '    address private admin;\n', '    \n', '    address private founder;\n', '    \n', '    bool public isTransferable = false;\n', '    \n', '    string public name;\n', '    \n', '    string public symbol;\n', '    \n', '    uint256 public __totalSupply;\n', '    \n', '    uint8 public decimals;\n', '    \n', '    constructor(string _name, string _symbol, uint256 _totalSupply, uint8 _decimals, address _founder, address _admin) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        __totalSupply = _totalSupply;\n', '        decimals = _decimals;\n', '        admin = _admin;\n', '        founder = _founder;\n', '        accounts[founder].init_balance = __totalSupply;\n', '        accounts[founder].balance = __totalSupply;\n', '        emit Transfer(0x0, founder, __totalSupply);\n', '    }\n', '    \n', '    // define onlyAdmin\n', '    modifier onlyAdmin {\n', '        require(admin == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    // define onlyFounder\n', '    modifier onlyFounder {\n', '        require(founder == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    // define transferable\n', '    modifier transferable {\n', '        require(isTransferable);\n', '        _;\n', '    }\n', '    \n', '    // define notLocked\n', '    modifier notLocked {\n', '        require(!lockedAddresses[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function totalSupply() public constant returns (uint256) {\n', '        return __totalSupply;\n', '    }\n', '\n', '    // ERC20 spec.\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return accounts[_owner].balance;\n', '    }\n', '        \n', '    // ERC20 spec.\n', '    function transfer(address _to, uint256 _value) transferable notLocked public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= accounts[msg.sender].balance);\n', '\n', '        if (!checkTime(msg.sender, _value)) return false;\n', '\n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function transferFrom(address _from, address _to, uint256 _value) transferable notLocked public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= accounts[_from].balance);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(!lockedAddresses[_from]);\n', '\n', '        if (!checkTime(_from, _value)) return false;\n', '\n', '        accounts[_from].balance = accounts[_from].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function approve(address _spender, uint256 _value) transferable notLocked public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // Founder distributes initial balance\n', '    function distribute(address _to, uint256 _value) onlyFounder public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= accounts[msg.sender].balance);\n', '        \n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        accounts[_to].init_balance = accounts[_to].init_balance.add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // Change founder\n', '    function changeFounder(address who) onlyFounder public {   \n', '        founder = who;\n', '    }\n', '\n', '    // show founder address\n', '    function getFounder() onlyFounder public view returns (address) {\n', '        return founder;\n', '    }\n', '\n', '    // Change admin\n', '    function changeAdmin(address who) onlyAdmin public {\n', '        admin = who;\n', '    }\n', '\n', '    // show founder address\n', '    function getAdmin() onlyAdmin public view returns (address) {\n', '        return admin;\n', '    }\n', '\n', '    \n', '    // Lock individual transfer flag\n', '    function lock(address who) onlyAdmin public {\n', '        \n', '        lockedAddresses[who] = true;\n', '    }\n', '\n', '    // Unlock individual transfer flag\n', '    function unlock(address who) onlyAdmin public {\n', '        \n', '        lockedAddresses[who] = false;\n', '    }\n', '    \n', '    // Check individual transfer flag\n', '    function isLocked(address who) public view returns(bool) {\n', '        \n', '        return lockedAddresses[who];\n', '    }\n', '\n', '    // Enable global transfer flag\n', '    function enableTransfer() onlyAdmin public {\n', '        \n', '        isTransferable = true;\n', '    }\n', '    \n', '    // Disable global transfer flag \n', '    function disableTransfer() onlyAdmin public {\n', '        \n', '        isTransferable = false;\n', '    }\n', '\n', '    // check unlock time and init balance for each account\n', '    function checkTime(address who, uint256 _value) public view returns (bool) {\n', '        uint256 total_percent;\n', '        uint256 total_vol;\n', '\n', '        total_vol = accounts[who].init_balance.sub(accounts[who].balance);\n', '        total_vol = total_vol.add(_value);\n', '\n', '        if (accounts[who].unlockTime1 > now) {\n', '           return false;\n', '        } else if (accounts[who].unlockTime2 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        } else if (accounts[who].unlockTime3 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '\n', '        } else if (accounts[who].unlockTime4 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent3);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        } else if (accounts[who].unlockTime5 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent3);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent4);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        } else { \n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent3);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent4);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent5);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        }\n', '        \n', '        return true; \n', '       \n', '    }\n', '\n', '    // Founder sets unlockTime1\n', '    function setTime1(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime1 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime1(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime1;\n', '    }\n', '\n', '    // Founder sets unlockTime2\n', '    function setTime2(address who, uint256 value) onlyFounder public returns (bool) {\n', '\n', '        accounts[who].unlockTime2 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime2(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime2;\n', '    }\n', '\n', '    // Founder sets unlockTime3\n', '    function setTime3(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime3 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime3(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime3;\n', '    }\n', '\n', '    // Founder sets unlockTime4\n', '    function setTime4(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime4 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime4(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime4;\n', '    }\n', '\n', '    // Founder sets unlockTime5\n', '    function setTime5(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime5 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime5(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime5;\n', '    }\n', '\n', '    // Founder sets unlockPercent1\n', '    function setPercent1(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent1 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent1(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent1;\n', '    }\n', '\n', '    // Founder sets unlockPercent2\n', '    function setPercent2(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent2 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent2(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent2;\n', '    }\n', '\n', '    // Founder sets unlockPercent3\n', '    function setPercent3(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent3 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent3(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent3;\n', '    }\n', '\n', '    // Founder sets unlockPercent4\n', '    function setPercent4(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent4 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent4(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent4;\n', '    }\n', '\n', '    // Founder sets unlockPercent5\n', '    function setPercent5(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent5 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent5(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent5;\n', '    }\n', '\n', '    // get init_balance\n', '    function getInitBalance(address _owner) public view returns (uint256) {\n', '        return accounts[_owner].init_balance;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '// produced by the Solididy File Flattener (c) David Appleton 2018\n', '// contact : dave@akomba.com\n', '// released under Apache 2.0 licence\n', '// input  /Users/chae/dev/colorcoin/coin-ver2/color-erc20.sol\n', '// flattened :  Thursday, 10-Jan-19 03:27:25 UTC\n', 'library SafeMath {\n', '    \n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        \n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '    \n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;   \n', '    }\n', '    \n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', ' \n', '    // Get the total token supply\n', '    function totalSupply() public constant returns (uint256);\n', '\n', '    // Get the account balance of another account with address _owner   \n', '    function balanceOf(address who) public view returns (uint256);\n', '    \n', '    // Send _value amount of tokens to address _to\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    \n', '    // Send _value amount of tokens from address _from to address _to\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '\n', '    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.\n', '    // If this function is called again it overwrites the current allowance with _value.\n', '    // this function is required for some DEX functionality   \n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    // Returns the amount which _spender is still allowed to withdraw from _owner\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', ' \n', '    // Triggered when tokens are transferred. \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    // Triggered whenever approve(address _spender, uint256 _value) is called. \n', '    event Approval(address indexed owner,address indexed spender,uint256 value);\n', ' \n', '}\n', '\n', '//\n', '// Color Coin v2.0\n', '// \n', 'contract ColorCoin is ERC20 {\n', '\n', '    // Time Lock and Vesting\n', '    struct accountData {\n', '      uint256 init_balance;\n', '      uint256 balance;\n', '      uint256 unlockTime1;\n', '      uint256 unlockTime2;\n', '      uint256 unlockTime3;\n', '      uint256 unlockTime4;\n', '      uint256 unlockTime5;\n', '\n', '      uint256 unlockPercent1;\n', '      uint256 unlockPercent2;\n', '      uint256 unlockPercent3;\n', '      uint256 unlockPercent4;\n', '      uint256 unlockPercent5;\n', '    }\n', '    \n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    \n', '    mapping(address => accountData) private accounts;\n', '    \n', '    mapping(address => bool) private lockedAddresses;\n', '    \n', '    address private admin;\n', '    \n', '    address private founder;\n', '    \n', '    bool public isTransferable = false;\n', '    \n', '    string public name;\n', '    \n', '    string public symbol;\n', '    \n', '    uint256 public __totalSupply;\n', '    \n', '    uint8 public decimals;\n', '    \n', '    constructor(string _name, string _symbol, uint256 _totalSupply, uint8 _decimals, address _founder, address _admin) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        __totalSupply = _totalSupply;\n', '        decimals = _decimals;\n', '        admin = _admin;\n', '        founder = _founder;\n', '        accounts[founder].init_balance = __totalSupply;\n', '        accounts[founder].balance = __totalSupply;\n', '        emit Transfer(0x0, founder, __totalSupply);\n', '    }\n', '    \n', '    // define onlyAdmin\n', '    modifier onlyAdmin {\n', '        require(admin == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    // define onlyFounder\n', '    modifier onlyFounder {\n', '        require(founder == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    // define transferable\n', '    modifier transferable {\n', '        require(isTransferable);\n', '        _;\n', '    }\n', '    \n', '    // define notLocked\n', '    modifier notLocked {\n', '        require(!lockedAddresses[msg.sender]);\n', '        _;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function totalSupply() public constant returns (uint256) {\n', '        return __totalSupply;\n', '    }\n', '\n', '    // ERC20 spec.\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return accounts[_owner].balance;\n', '    }\n', '        \n', '    // ERC20 spec.\n', '    function transfer(address _to, uint256 _value) transferable notLocked public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= accounts[msg.sender].balance);\n', '\n', '        if (!checkTime(msg.sender, _value)) return false;\n', '\n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function transferFrom(address _from, address _to, uint256 _value) transferable notLocked public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= accounts[_from].balance);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        require(!lockedAddresses[_from]);\n', '\n', '        if (!checkTime(_from, _value)) return false;\n', '\n', '        accounts[_from].balance = accounts[_from].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function approve(address _spender, uint256 _value) transferable notLocked public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    // ERC20 spec.\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    // Founder distributes initial balance\n', '    function distribute(address _to, uint256 _value) onlyFounder public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= accounts[msg.sender].balance);\n', '        \n', '        accounts[msg.sender].balance = accounts[msg.sender].balance.sub(_value);\n', '        accounts[_to].balance = accounts[_to].balance.add(_value);\n', '        accounts[_to].init_balance = accounts[_to].init_balance.add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // Change founder\n', '    function changeFounder(address who) onlyFounder public {   \n', '        founder = who;\n', '    }\n', '\n', '    // show founder address\n', '    function getFounder() onlyFounder public view returns (address) {\n', '        return founder;\n', '    }\n', '\n', '    // Change admin\n', '    function changeAdmin(address who) onlyAdmin public {\n', '        admin = who;\n', '    }\n', '\n', '    // show founder address\n', '    function getAdmin() onlyAdmin public view returns (address) {\n', '        return admin;\n', '    }\n', '\n', '    \n', '    // Lock individual transfer flag\n', '    function lock(address who) onlyAdmin public {\n', '        \n', '        lockedAddresses[who] = true;\n', '    }\n', '\n', '    // Unlock individual transfer flag\n', '    function unlock(address who) onlyAdmin public {\n', '        \n', '        lockedAddresses[who] = false;\n', '    }\n', '    \n', '    // Check individual transfer flag\n', '    function isLocked(address who) public view returns(bool) {\n', '        \n', '        return lockedAddresses[who];\n', '    }\n', '\n', '    // Enable global transfer flag\n', '    function enableTransfer() onlyAdmin public {\n', '        \n', '        isTransferable = true;\n', '    }\n', '    \n', '    // Disable global transfer flag \n', '    function disableTransfer() onlyAdmin public {\n', '        \n', '        isTransferable = false;\n', '    }\n', '\n', '    // check unlock time and init balance for each account\n', '    function checkTime(address who, uint256 _value) public view returns (bool) {\n', '        uint256 total_percent;\n', '        uint256 total_vol;\n', '\n', '        total_vol = accounts[who].init_balance.sub(accounts[who].balance);\n', '        total_vol = total_vol.add(_value);\n', '\n', '        if (accounts[who].unlockTime1 > now) {\n', '           return false;\n', '        } else if (accounts[who].unlockTime2 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        } else if (accounts[who].unlockTime3 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '\n', '        } else if (accounts[who].unlockTime4 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent3);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        } else if (accounts[who].unlockTime5 > now) {\n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent3);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent4);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        } else { \n', '           total_percent = accounts[who].unlockPercent1;\n', '           total_percent = total_percent.add(accounts[who].unlockPercent2);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent3);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent4);\n', '           total_percent = total_percent.add(accounts[who].unlockPercent5);\n', '\n', '           if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) \n', '             return false;\n', '        }\n', '        \n', '        return true; \n', '       \n', '    }\n', '\n', '    // Founder sets unlockTime1\n', '    function setTime1(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime1 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime1(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime1;\n', '    }\n', '\n', '    // Founder sets unlockTime2\n', '    function setTime2(address who, uint256 value) onlyFounder public returns (bool) {\n', '\n', '        accounts[who].unlockTime2 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime2(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime2;\n', '    }\n', '\n', '    // Founder sets unlockTime3\n', '    function setTime3(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime3 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime3(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime3;\n', '    }\n', '\n', '    // Founder sets unlockTime4\n', '    function setTime4(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime4 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime4(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime4;\n', '    }\n', '\n', '    // Founder sets unlockTime5\n', '    function setTime5(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockTime5 = value;\n', '        return true;\n', '    }\n', '\n', '    function getTime5(address who) public view returns (uint256) {\n', '        return accounts[who].unlockTime5;\n', '    }\n', '\n', '    // Founder sets unlockPercent1\n', '    function setPercent1(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent1 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent1(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent1;\n', '    }\n', '\n', '    // Founder sets unlockPercent2\n', '    function setPercent2(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent2 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent2(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent2;\n', '    }\n', '\n', '    // Founder sets unlockPercent3\n', '    function setPercent3(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent3 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent3(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent3;\n', '    }\n', '\n', '    // Founder sets unlockPercent4\n', '    function setPercent4(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent4 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent4(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent4;\n', '    }\n', '\n', '    // Founder sets unlockPercent5\n', '    function setPercent5(address who, uint256 value) onlyFounder public returns (bool) {\n', '        accounts[who].unlockPercent5 = value;\n', '        return true;\n', '    }\n', '\n', '    function getPercent5(address who) public view returns (uint256) {\n', '        return accounts[who].unlockPercent5;\n', '    }\n', '\n', '    // get init_balance\n', '    function getInitBalance(address _owner) public view returns (uint256) {\n', '        return accounts[_owner].init_balance;\n', '    }\n', '}']
