['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-10\n', '*/\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Symbol      : STUM\n', '// Name        : STOTUM\n', '// Total supply: 100,000,000.00000000\n', '// Decimals    : 18\n', '// ----------------------------------------------------------------------------\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract iERC223Token {\n', '    function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '    function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);\n', '}\n', '\n', 'contract ERC223Receiver {\n', '    function tokenFallback( address _origin, uint _value, bytes _data) public returns (bool ok);\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract iERC20Token {\n', '    uint256 public totalSupply = 0;\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract StandardToken is iERC20Token {\n', '\n', '    using SafeMath for uint256;\n', '    mapping(address => uint) balances;\n', '    mapping (address => mapping (address => uint)) allowed;\n', '\n', '    function transfer(address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '   /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract FreezableToken is iERC223Token, StandardToken, Ownable {\n', '\n', '    event ContractTransfer(address indexed _from, address indexed _to, uint _value, bytes _data);\n', '\n', '    bool public freezed;\n', '\n', '    modifier canTransfer(address _transferer) {\n', '        require(owner == _transferer || !freezed);\n', '        _;\n', '    }\n', '\n', '    function FreezableToken() public {\n', '        freezed = true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value, bytes _data) canTransfer(msg.sender)\n', '        public\n', '        canTransfer(msg.sender)\n', '        returns (bool success) {\n', '        //filtering if the target is a contract with bytecode inside it\n', '        require(super.transfer(_to, _value)); // do a normal token transfer\n', '        if (isContract(_to)) {\n', '            require(contractFallback(msg.sender, _to, _value, _data));\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value, bytes _data) public canTransfer(msg.sender) returns (bool success) {\n', '        require(super.transferFrom(_from, _to, _value)); // do a normal token transfer\n', '        if (isContract(_to)) {\n', '            require(contractFallback(_from, _to, _value, _data));\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) canTransfer(msg.sender) public canTransfer(msg.sender) returns (bool success) {\n', '        return transfer(_to, _value, new bytes(0));\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {\n', '        return transferFrom(_from, _to, _value, new bytes(0));\n', '    }\n', '\n', '    //function that is called when transaction target is a contract\n', '    function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool) {\n', '        emit ContractTransfer(_origin, _to, _value, _data);\n', '        ERC223Receiver reciever = ERC223Receiver(_to);\n', '        require(reciever.tokenFallback(_origin, _value, _data));\n', '        return true;\n', '    }\n', '\n', '    //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '    function isContract(address _addr) private view returns (bool is_contract) {\n', '        uint length;\n', '        assembly { length := extcodesize(_addr) }\n', '        return length > 0;\n', '    }\n', '\n', '    function unfreeze() public onlyOwner returns (bool){\n', '        freezed = false;\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract StotumToken is FreezableToken {\n', '\n', '    string public constant name = &#39;Stotum&#39;;\n', '    string public constant symbol = &#39;STUM&#39;;\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant totalSupply = 100000000 * (10 ** uint256(decimals));\n', '\n', '    function StotumToken() public {\n', '        balances[msg.sender]  = totalSupply;\n', '    }\n', '}']