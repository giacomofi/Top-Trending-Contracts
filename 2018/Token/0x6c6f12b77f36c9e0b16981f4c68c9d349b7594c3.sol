['pragma solidity ^0.4.24;\n', '\n', 'interface ERC165 {\n', '    /// @notice Query if a contract implements an interface\n', '    /// @param interfaceID The interface identifier, as specified in ERC-165\n', '    /// @dev Interface identification is specified in ERC-165. This function\n', '    ///  uses less than 30,000 gas.\n', '    /// @return `true` if the contract implements `interfaceID` and\n', '    ///  `interfaceID` is not 0xffffffff, `false` otherwise\n', '    function supportsInterface(bytes4 interfaceID) external view returns (bool);\n', '}\n', '\n', '\n', 'contract CRAM {\n', '\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) private balances;\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '    mapping (bytes4 => bool) internal supportedInterfaces;\n', '\n', '    constructor() public {\n', '        totalSupply = 333333333;\n', '        balances[msg.sender] = totalSupply;\n', '        name = "CRAM COIN!";\n', '        decimals = 0;\n', '        symbol = "CRAM!";\n', '        supportedInterfaces[0x01ffc9a7] = true;\n', '        supportedInterfaces[0x36372b07] = true;\n', '        supportedInterfaces[0x942e8b22] = true;\n', '    }\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Cram(address indexed _from, address indexed _to, uint256 _value, string _message);\n', '\n', '    function supportsInterface(bytes4 interfaceID) external view returns (bool) {\n', '      require(interfaceID != 0xffffffff);\n', '      return supportedInterfaces[interfaceID];\n', '    }\n', '\n', '    function () public {\n', '        //if ether is sent to this address, send it back.\n', '        revert("You cannot buy CRAM! Coins, you fool.");\n', '    }\n', '\n', '    function cram(address _to, uint256 _value, string _message) external returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Cram(msg.sender, _to, _value, _message);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success) {\n', '        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.\n', '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }\n', '        return true;\n', '    }\n', '\n', '}']