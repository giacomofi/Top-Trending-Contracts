['pragma solidity ^0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract owned {\n', '\n', '    address public owner;\n', '\n', '    function owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract saleOwned is owned{\n', '    mapping (address => bool) public saleContract;\n', '\n', '    modifier onlySaleOwner {        \n', '        require(msg.sender == owner || true == saleContract[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function addSaleOwner(address saleOwner) onlyOwner public {\n', '        saleContract[saleOwner] = true;\n', '    }\n', '\n', '    function delSaleOwner(address saleOwner) onlyOwner public {\n', '        saleContract[saleOwner] = false;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is saleOwned {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '    modifier whenNotPaused() {\n', '        require(false == paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '    modifier whenPaused {\n', '        require(true == paused);\n', '        _;\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '    function pause() onlyOwner whenNotPaused public returns (bool) {\n', '        paused = true;\n', '        emit Pause();\n', '        return true;\n', '    }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '    function unpause() onlyOwner whenPaused public returns (bool) {\n', '        paused = false;\n', '        emit Unpause();\n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       BASE TOKEN STARTS HERE       */\n', '/******************************************/\n', 'contract BaseToken is Pausable{\n', '    using SafeMath for uint256;    \n', '    \n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256))  approvals;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event TransferFrom(address indexed approval, address indexed from, address indexed to, uint256 value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '\n', '    function BaseToken (\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public {\n', '        decimals = 18;\n', '        name = tokenName;\n', '        symbol = tokenSymbol;\n', '    }    \n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);\n', '        require (balanceOf[_from] >= _value);\n', '        require (balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) whenNotPaused public {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool) {\n', '        assert(balanceOf[_from] >= _value);\n', '        assert(approvals[_from][msg.sender] >= _value);\n', '        \n', '        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '\n', '    function allowance(address src, address guy) public view returns (uint256) {\n', '        return approvals[src][guy];\n', '    }\n', '\n', '    function approve(address guy, uint256 _value) public returns (bool) {\n', '        approvals[msg.sender][guy] = _value;\n', '        \n', '        emit Approval(msg.sender, guy, _value);\n', '        \n', '        return true;\n', '    }\n', '}\n', '\n', '/******************************************/\n', '/*       ADVANCED TOKEN STARTS HERE       */\n', '/******************************************/\n', 'contract AdvanceToken is BaseToken {\n', '    string tokenName        = "BetEncore";       // Set the name for display purposes\n', '    string tokenSymbol      = "BTEN";            // Set the symbol for display purposes\n', '\n', '    struct frozenStruct {\n', '        uint startTime;\n', '        uint endTime;\n', '    }\n', '    \n', '    mapping (address => bool) public frozenAccount;\n', '    mapping (address => frozenStruct) public frozenTime;\n', '\n', '    event FrozenFunds(address target, bool frozen, uint startTime, uint endTime);    \n', '    event Burn(address indexed from, uint256 value);\n', '    \n', '    function AdvanceToken() BaseToken(tokenName, tokenSymbol) public {}\n', '    \n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead\n', '        require (balanceOf[_from] >= _value);               // Check if the sender has enough\n', '        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows\n', '        require(false == isFrozen(_from));                  // Check if sender is frozen\n', '        if(saleContract[_from] == false)                    // for refund\n', '            require(false == isFrozen(_to));                // Check if recipient is frozen\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender\n', '        balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient\n', '\n', '        emit Transfer(_from, _to, _value);\n', '    }    \n', '\n', '    function mintToken(uint256 mintedAmount) onlyOwner public {\n', '        uint256 mintSupply = mintedAmount.mul(10 ** uint256(decimals));\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(mintSupply);\n', '        totalSupply = totalSupply.add(mintSupply);\n', '        emit Transfer(0, this, mintSupply);\n', '        emit Transfer(this, msg.sender, mintSupply);\n', '    }\n', '\n', '    function isFrozen(address target) public view returns (bool success) {        \n', '        if(false == frozenAccount[target])\n', '            return false;\n', '\n', '        if(frozenTime[target].startTime <= now && now <= frozenTime[target].endTime)\n', '            return true;\n', '        \n', '        return false;\n', '    }\n', '\n', '    function freezeAccount(address target, bool freeze, uint startTime, uint endTime) onlySaleOwner public {\n', '        frozenAccount[target] = freeze;\n', '        frozenTime[target].startTime = startTime;\n', '        frozenTime[target].endTime = endTime;\n', '        emit FrozenFunds(target, freeze, startTime, endTime);\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '}']