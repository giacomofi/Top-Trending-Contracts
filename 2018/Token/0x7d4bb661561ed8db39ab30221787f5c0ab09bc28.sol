['pragma solidity ^0.4.21;\n', '\n', 'contract ERC20Token{\n', '    //ERC20 base standard\n', '    uint256 public totalSupply;\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Owned{\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier onlyOwner {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still need to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '/*\n', '    Overflow protected math functions\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '        constructor\n', '    */\n', '    function SafeMath() public{\n', '    }\n', '\n', '       // Check if it is safe to add two numbers\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint c = a + b;\n', '        assert(c >= a && c >= b);\n', '        return c;\n', '    }\n', '\n', '    // Check if it is safe to subtract two numbers\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint c = a - b;\n', '        assert(b <= a && c <= a);\n', '        return c;\n', '    }\n', '\n', '    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint c = a * b;\n', '        assert(a == 0 || (c / a) == b);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', 'contract MANXERC20 is SafeMath, ERC20Token, Owned {\n', '    string public constant name = &#39;MacroChain Computing And Networking System&#39;;                              // Set the token name for display\n', '    string public constant symbol = &#39;MANX&#39;;                                  // Set the token symbol for display\n', '    uint8 public constant decimals = 18;                                     // Set the number of decimals for display\n', '    uint256 public constant INITIAL_SUPPLY = 10000000000 * 10 ** uint256(decimals);\n', '    uint256 public totalSupply;\n', '    string public version = &#39;1&#39;;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    \n', '    modifier rejectTokensToContract(address _to) {\n', '        require(_to != address(this));\n', '        _;\n', '    }\n', '    \n', '    function MANXERC20() public {\n', '        totalSupply = INITIAL_SUPPLY;                              // Set the total supply\n', '        balances[msg.sender] = INITIAL_SUPPLY;                     // Creator address is assigned all\n', '        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '        balances[_to] = safeAdd(balances[_to], _value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = safeSub(balances[_from],_value);\n', '        balances[_to] = safeAdd(balances[_to],_value);\n', '        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '    \n', '    function approveAndCallN(address _spender, uint256 _value, uint256 _extraNum) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        //similar to the above, the passed value is a number\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,uint256)"))), msg.sender, _value, this, _extraNum)) { revert(); }\n', '        return true;\n', '    }\n', '\n', '\n', '}']