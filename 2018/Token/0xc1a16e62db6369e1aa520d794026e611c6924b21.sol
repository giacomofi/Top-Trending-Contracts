['pragma solidity ^0.4.23;\n', '\n', '\n', 'contract EIP20Interface {\n', '\n', '    uint256 public totalSupply;\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "      // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "      // benefit is lost if 'b' is also tested.\n", '      // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }   \n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '      // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '      // uint256 c = a / b;\n', "      // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', 'contract CommunicationCreatesValueToken is EIP20Interface {\n', '    using SafeMath for uint256;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    \n', '    \n', '    mapping(address => uint256) public balanceOf;\n', '    mapping(address => uint256) public freezeOf;\n', '    mapping(address => mapping(address=> uint256)) allowed;\n', '\n', '    /* This notifies clients about the amount burnt */\n', '    event Burn(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount frozen */\n', '    event Freeze(address indexed from, uint256 value);\n', '\t\n', '\t/* This notifies clients about the amount unfrozen */\n', '    event Unfreeze(address indexed from, uint256 value);\n', '\n', '    constructor (\n', '        string _name,\n', '        string _symbol,\n', '        uint8 _decimals,\n', '        uint256 _totalSupply\n', '    ) public {\n', '        balanceOf[msg.sender] = _totalSupply;\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _totalSupply;\n', '    }   \n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(_to != address(0));\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value); \n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        uint256 allowance = allowed[_from][msg.sender];\n', '        require(_to != address(0));\n', '        require(balanceOf[_from] >= _value && allowance >= _value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value); \n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balanceOf[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function freeze(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough\n', '        require(_value>0);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                      // Subtract from the sender\n', '        freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);                                // Updates totalSupply\n', '        emit Freeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function unfreeze(uint256 _value) public returns (bool success) {\n', '        require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough\n', '\t    require(_value>0);\n', '        freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);                      // Subtract from the sender\n', '\t\tbalanceOf[msg.sender] = balanceOf[msg.sender].add(_value);\n', '        emit Unfreeze(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }   \n', '\n', '    /**\n', '    * @dev Burns a specific amount of tokens.\n', '    * @param _value The amount of token to be burned.\n', '    */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balanceOf[_who]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', "        // sender's balance is greater than the totalSupply, which *should* be an assertion failure\n", '\n', '        balanceOf[_who] = balanceOf[_who].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '}\n', '\n', 'contract CommunicationCreatesValueTokenLock {\n', '  // ERC20 basic token contract being held\n', '    CommunicationCreatesValueToken public token;\n', '\n', '  // beneficiary of tokens after they are released\n', '    address public beneficiary;\n', '\n', '  // timestamp when token release is enabled\n', '    uint256 public openingTime;\n', '    \n', '    uint256 public totalFreeze;\n', '\n', '    mapping(uint => uint) public unfreezed;\n', '\n', '    constructor(\n', '        CommunicationCreatesValueToken _token,\n', '        address _beneficiary,\n', '        uint256 _openingTime,\n', '        uint256 _totalFreeze\n', '    )\n', '        public\n', '    {\n', '        token = _token;\n', '        beneficiary = _beneficiary;\n', '        openingTime = _openingTime;\n', '        totalFreeze = _totalFreeze;\n', '    }\n', '\n', '  /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '    function release() public {\n', '        uint256 nowTime = block.timestamp;\n', '        uint256 passTime = nowTime - openingTime;\n', '        uint256 weeksnow = passTime/2419200;\n', '        require(unfreezed[weeksnow] != 1, "This week we have unfreeze part of the token");\n', '        uint256 amount = getPartReleaseAmount();\n', '        require(amount > 0, "the token has finished released");\n', '        unfreezed[weeksnow] = 1;\n', '        token.transfer(beneficiary, amount);\n', '    }\n', '\n', '    /**\n', '    *@dev getMonthRelease is the function to get todays month realse\n', '    *\n', '    */\n', '    function getPartReleaseAmount() public view returns(uint256){\n', '        uint stage = getStage();\n', '        for( uint i = 0; i <= stage; i++ ) {\n', '            uint256 stageAmount = totalFreeze/2;\n', '        }\n', '        uint256 amount = stageAmount*2419200/126230400;\n', '        return amount;\n', '    }\n', '    \n', '    /**\n', '    *@dev getStage is the function to get which stage the lock is on, four year will change the stage\n', '    *@return uint256\n', '    */\n', '    function getStage() public view returns(uint256) {\n', '        uint256 nowTime = block.timestamp;\n', '        uint256 passTime = nowTime - openingTime;\n', '        uint256 stage = passTime/126230400;       //stage is the lock is on, a day is 86400 seconds\n', '        return stage;\n', '    }\n', '}']