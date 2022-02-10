['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', 'contract ERC20Interface {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool ok);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok);\n', '    function approve(address _spender, uint256 _value) public returns (bool ok);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '    function multiply(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function divide(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function subtract(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/StandardToken.sol\n', '\n', 'contract StandardToken is ERC20Interface {\n', '    using SafeMath for uint256;\n', '\n', '    /* Actual balances of token holders */\n', '    mapping(address => uint) balances;\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    /**\n', '     *\n', '     * Fix for the ERC20 short address attack\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    modifier onlyPayloadSize(uint256 size) {\n', '        require(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool ok) {\n', '        require(_to != address(0));\n', '        require(_value > 0);\n', '        uint256 holderBalance = balances[msg.sender];\n', '        require(_value <= holderBalance);\n', '\n', '        balances[msg.sender] = holderBalance.subtract(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {\n', '        require(_to != address(0));\n', '        uint256 allowToTrans = allowed[_from][msg.sender];\n', '        uint256 balanceFrom = balances[_from];\n', '        require(_value <= balanceFrom);\n', '        require(_value <= allowToTrans);\n', '\n', '        balances[_from] = balanceFrom.subtract(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowToTrans.subtract(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns balance of the `_owner`.\n', '     *\n', '     * @param _owner   The address whose balance will be returned.\n', '     * @return balance Balance of the `_owner`.\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool ok) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        //    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '        //    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Atomic increment of approved spending\n', '     *\n', '     * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     */\n', '    function increaseApproval(address _spender, uint256 _addedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        allowed[msg.sender][_spender] = oldValue.add(_addedValue);\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Atomic decrement of approved spending.\n', '     *\n', '     * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.subtract(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/BurnableToken.sol\n', '\n', 'contract BurnableToken is StandardToken {\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _holder, uint256 _value) internal {\n', '        require(_value <= balances[_holder]);\n', '\n', '        balances[_holder] = balances[_holder].subtract(_value);\n', '        totalSupply = totalSupply.subtract(_value);\n', '\n', '        emit Burn(_holder, _value);\n', '        emit Transfer(_holder, address(0), _value);\n', '    }\n', '\n', '    event Burn(address indexed _burner, uint256 _value);\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '\n', '        emit OwnershipTransferred(owner, newOwner);\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', '// File: contracts/ERC223Interface.sol\n', '\n', 'contract ERC223Interface is ERC20Interface {\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);\n', '}\n', '\n', '// File: contracts/ERC223ReceivingContract.sol\n', '\n', 'contract ERC223ReceivingContract {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) public;\n', '}\n', '\n', '// File: contracts/Standard223Token.sol\n', '\n', 'contract Standard223Token is ERC223Interface, StandardToken {\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok) {\n', '        if (!super.transfer(_to, _value)) {\n', '            revert();\n', '        }\n', '        if (isContract(_to)) {\n', '            contractFallback(msg.sender, _to, _value, _data);\n', '        }\n', '\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool ok) {\n', '        return transfer(_to, _value, new bytes(0));\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool ok) {\n', '        if (!super.transferFrom(_from, _to, _value)) {\n', '            revert();\n', '        }\n', '        if (isContract(_to)) {\n', '            contractFallback(_from, _to, _value, _data);\n', '        }\n', '\n', '        emit Transfer(_from, _to, _value, _data);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {\n', '        return transferFrom(_from, _to, _value, new bytes(0));\n', '    }\n', '\n', '    function contractFallback(address _origin, address _to, uint256 _value, bytes _data) private {\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(_origin, _value, _data);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint256 length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '\n', '        return (length > 0);\n', '    }\n', '}\n', '\n', '// File: contracts/ICOToken.sol\n', '\n', '// ----------------------------------------------------------------------------\n', '// ICO Token contract\n', '// ----------------------------------------------------------------------------\n', 'contract ICOToken is BurnableToken, Ownable, Standard223Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[owner] = totalSupply;\n', '\n', '        emit Mint(owner, totalSupply);\n', '        emit Transfer(address(0), owner, totalSupply);\n', '        emit MintFinished();\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    event Mint(address indexed _to, uint256 _amount);\n', '    event MintFinished();\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// File: contracts/ERC20Interface.sol\n', '\n', 'contract ERC20Interface {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool ok);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok);\n', '    function approve(address _spender, uint256 _value) public returns (bool ok);\n', '    function allowance(address _owner, address _spender) public constant returns (uint256);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '    function multiply(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function divide(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b > 0);\n', '        uint256 c = a / b;\n', '        assert(a == b * c + a % b);\n', '        return c;\n', '    }\n', '\n', '    function subtract(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '}\n', '\n', '// File: contracts/StandardToken.sol\n', '\n', 'contract StandardToken is ERC20Interface {\n', '    using SafeMath for uint256;\n', '\n', '    /* Actual balances of token holders */\n', '    mapping(address => uint) balances;\n', '    /* approve() allowances */\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    /**\n', '     *\n', '     * Fix for the ERC20 short address attack\n', '     *\n', '     * http://vessenes.com/the-erc20-short-address-attack-explained/\n', '     */\n', '    modifier onlyPayloadSize(uint256 size) {\n', '        require(msg.data.length == size + 4);\n', '        _;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool ok) {\n', '        require(_to != address(0));\n', '        require(_value > 0);\n', '        uint256 holderBalance = balances[msg.sender];\n', '        require(_value <= holderBalance);\n', '\n', '        balances[msg.sender] = holderBalance.subtract(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {\n', '        require(_to != address(0));\n', '        uint256 allowToTrans = allowed[_from][msg.sender];\n', '        uint256 balanceFrom = balances[_from];\n', '        require(_value <= balanceFrom);\n', '        require(_value <= allowToTrans);\n', '\n', '        balances[_from] = balanceFrom.subtract(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowToTrans.subtract(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns balance of the `_owner`.\n', '     *\n', '     * @param _owner   The address whose balance will be returned.\n', '     * @return balance Balance of the `_owner`.\n', '     */\n', '    function balanceOf(address _owner) public constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool ok) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        //    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '        //    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '     * Atomic increment of approved spending\n', '     *\n', '     * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     */\n', '    function increaseApproval(address _spender, uint256 _addedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        allowed[msg.sender][_spender] = oldValue.add(_addedValue);\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Atomic decrement of approved spending.\n', '     *\n', '     * Works around https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     */\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) onlyPayloadSize(2 * 32) public returns (bool ok) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.subtract(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/BurnableToken.sol\n', '\n', 'contract BurnableToken is StandardToken {\n', '    /**\n', '     * @dev Burns a specific amount of tokens.\n', '     * @param _value The amount of token to be burned.\n', '     */\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _holder, uint256 _value) internal {\n', '        require(_value <= balances[_holder]);\n', '\n', '        balances[_holder] = balances[_holder].subtract(_value);\n', '        totalSupply = totalSupply.subtract(_value);\n', '\n', '        emit Burn(_holder, _value);\n', '        emit Transfer(_holder, address(0), _value);\n', '    }\n', '\n', '    event Burn(address indexed _burner, uint256 _value);\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '\n', '        emit OwnershipTransferred(owner, newOwner);\n', '    }\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '}\n', '\n', '// File: contracts/ERC223Interface.sol\n', '\n', 'contract ERC223Interface is ERC20Interface {\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes indexed _data);\n', '}\n', '\n', '// File: contracts/ERC223ReceivingContract.sol\n', '\n', 'contract ERC223ReceivingContract {\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint256 _value, bytes _data) public;\n', '}\n', '\n', '// File: contracts/Standard223Token.sol\n', '\n', 'contract Standard223Token is ERC223Interface, StandardToken {\n', '    function transfer(address _to, uint256 _value, bytes _data) public returns (bool ok) {\n', '        if (!super.transfer(_to, _value)) {\n', '            revert();\n', '        }\n', '        if (isContract(_to)) {\n', '            contractFallback(msg.sender, _to, _value, _data);\n', '        }\n', '\n', '        emit Transfer(msg.sender, _to, _value, _data);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool ok) {\n', '        return transfer(_to, _value, new bytes(0));\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool ok) {\n', '        if (!super.transferFrom(_from, _to, _value)) {\n', '            revert();\n', '        }\n', '        if (isContract(_to)) {\n', '            contractFallback(_from, _to, _value, _data);\n', '        }\n', '\n', '        emit Transfer(_from, _to, _value, _data);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok) {\n', '        return transferFrom(_from, _to, _value, new bytes(0));\n', '    }\n', '\n', '    function contractFallback(address _origin, address _to, uint256 _value, bytes _data) private {\n', '        ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '        receiver.tokenFallback(_origin, _value, _data);\n', '    }\n', '\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint256 length;\n', '        assembly {\n', '            length := extcodesize(_addr)\n', '        }\n', '\n', '        return (length > 0);\n', '    }\n', '}\n', '\n', '// File: contracts/ICOToken.sol\n', '\n', '// ----------------------------------------------------------------------------\n', '// ICO Token contract\n', '// ----------------------------------------------------------------------------\n', 'contract ICOToken is BurnableToken, Ownable, Standard223Token {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[owner] = totalSupply;\n', '\n', '        emit Mint(owner, totalSupply);\n', '        emit Transfer(address(0), owner, totalSupply);\n', '        emit MintFinished();\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '\n', '    event Mint(address indexed _to, uint256 _amount);\n', '    event MintFinished();\n', '}']