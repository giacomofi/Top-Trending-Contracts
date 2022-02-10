['pragma solidity ^0.4.2;\n', '/**\n', ' * @title Contract for object that have an owner\n', ' */\n', 'contract Owned {\n', '    /**\n', '     * Contract owner address\n', '     */\n', '    address public owner;\n', '\n', '    /**\n', '     * @dev Store owner on creation\n', '     */\n', '    function Owned() { owner = msg.sender; }\n', '\n', '    /**\n', '     * @dev Delegate contract to another person\n', '     * @param _owner is another person address\n', '     */\n', '    function delegate(address _owner) onlyOwner\n', '    { owner = _owner; }\n', '\n', '    /**\n', '     * @dev Owner check modifier\n', '     */\n', '    modifier onlyOwner { if (msg.sender != owner) throw; _; }\n', '}\n', '/**\n', ' * @title Token contract represents any asset in digital economy\n', ' */\n', 'contract Token is Owned {\n', '    event Transfer(address indexed _from,  address indexed _to,      uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /* Short description of token */\n', '    string public name;\n', '    string public symbol;\n', '\n', '    /* Total count of tokens exist */\n', '    uint public totalSupply;\n', '\n', '    /* Fixed point position */\n', '    uint8 public decimals;\n', '    \n', '    /* Token approvement system */\n', '    mapping(address => uint) public balanceOf;\n', '    mapping(address => mapping(address => uint)) public allowance;\n', ' \n', '    /**\n', '     * @return available balance of `sender` account (self balance)\n', '     */\n', '    function getBalance() constant returns (uint)\n', '    { return balanceOf[msg.sender]; }\n', ' \n', '    /**\n', '     * @dev This method returns non zero result when sender is approved by\n', '     *      argument address and target address have non zero self balance\n', '     * @param _address target address \n', '     * @return available for `sender` balance of given address\n', '     */\n', '    function getBalance(address _address) constant returns (uint) {\n', '        return allowance[_address][msg.sender]\n', '             > balanceOf[_address] ? balanceOf[_address]\n', '                                   : allowance[_address][msg.sender];\n', '    }\n', ' \n', '    /* Token constructor */\n', '    function Token(string _name, string _symbol, uint8 _decimals, uint _count) {\n', '        name     = _name;\n', '        symbol   = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply           = _count;\n', '        balanceOf[msg.sender] = _count;\n', '    }\n', ' \n', '    /**\n', '     * @dev Transfer self tokens to given address\n', '     * @param _to destination address\n', '     * @param _value amount of token values to send\n', '     * @notice `_value` tokens will be sended to `_to`\n', '     * @return `true` when transfer done\n', '     */\n', '    function transfer(address _to, uint _value) returns (bool) {\n', '        if (balanceOf[msg.sender] >= _value) {\n', '            balanceOf[msg.sender] -= _value;\n', '            balanceOf[_to]        += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer with approvement mechainsm\n', '     * @param _from source address, `_value` tokens shold be approved for `sender`\n', '     * @param _to destination address\n', '     * @param _value amount of token values to send \n', '     * @notice from `_from` will be sended `_value` tokens to `_to`\n', '     * @return `true` when transfer is done\n', '     */\n', '    function transferFrom(address _from, address _to, uint _value) returns (bool) {\n', '        var avail = allowance[_from][msg.sender]\n', '                  > balanceOf[_from] ? balanceOf[_from]\n', '                                     : allowance[_from][msg.sender];\n', '        if (avail >= _value) {\n', '            allowance[_from][msg.sender] -= _value;\n', '            balanceOf[_from] -= _value;\n', '            balanceOf[_to]   += _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /**\n', '     * @dev Give to target address ability for self token manipulation without sending\n', '     * @param _address target address\n', '     * @param _value amount of token values for approving\n', '     */\n', '    function approve(address _address, uint _value) {\n', '        allowance[msg.sender][_address] += _value;\n', '        Approval(msg.sender, _address, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev Reset count of tokens approved for given address\n', '     * @param _address target address\n', '     */\n', '    function unapprove(address _address)\n', '    { allowance[msg.sender][_address] = 0; }\n', '}\n', '/**\n', ' * @title Ethereum crypto currency extention for Token contract\n', ' */\n', 'contract TokenEther is Token {\n', '    function TokenEther(string _name, string _symbol)\n', '             Token(_name, _symbol, 18, 0)\n', '    {}\n', '\n', '    /**\n', '     * @dev This is the way to withdraw money from token\n', '     * @param _value how many tokens withdraw from balance\n', '     */\n', '    function withdraw(uint _value) {\n', '        if (balanceOf[msg.sender] >= _value) {\n', '            balanceOf[msg.sender] -= _value;\n', '            totalSupply           -= _value;\n', '            if(!msg.sender.send(_value)) throw;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev This is the way to refill your token balance by ethers\n', '     */\n', '    function refill() payable returns (bool) {\n', '        balanceOf[msg.sender] += msg.value;\n', '        totalSupply           += msg.value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev This method is called when money sended to contract address,\n', '     *      a synonym for refill()\n', '     */\n', '    function () payable {\n', '        balanceOf[msg.sender] += msg.value;\n', '        totalSupply           += msg.value;\n', '    }\n', '}\n', 'contract AiraEtherFunds is TokenEther {\n', '    function AiraEtherFunds(string _name, string _symbol) TokenEther(_name, _symbol) {}\n', '\n', '    /**\n', '     * @dev Event spawned when activation request received\n', '     */\n', '    event ActivationRequest(address indexed sender, bytes32 indexed code);\n', '\n', '    /**\n', '     * @dev String to bytes32 conversion helper\n', '     */\n', '    function stringToBytes32(string memory source) constant returns (bytes32 result)\n', '    { assembly { result := mload(add(source, 32)) } }\n', '\n', '    // Balance limit\n', '    uint public limit;\n', '    \n', '    function setLimit(uint _limit) onlyOwner\n', '    { limit = _limit; }\n', '\n', '    // Account activation fee\n', '    uint public fee;\n', '    \n', '    function setFee(uint _fee) onlyOwner\n', '    { fee = _fee; }\n', '\n', '    // AiraEtherBot\n', '    address public bot;\n', '\n', '    function setBot(address _bot) onlyOwner\n', '    { bot = _bot; }\n', '\n', '    modifier onlyBot { if (msg.sender != bot) throw; _; }\n', '\n', '    /**\n', '     * @dev Refill balance and activate it by code\n', '     * @param _code is activation code\n', '     */\n', '    function activate(string _code) payable {\n', '        var value = msg.value;\n', ' \n', '        // Get a fee\n', '        if (fee > 0) {\n', '            if (value < fee) throw;\n', '            balanceOf[owner] += fee;\n', '            value            -= fee;\n', '        }\n', '\n', '        // Refund over limit\n', '        if (limit > 0 && value > limit) {\n', '            var refund = value - limit;\n', '            if (!msg.sender.send(refund)) throw;\n', '            value = limit;\n', '        }\n', '\n', '        // Refill account balance\n', '        balanceOf[msg.sender] += value;\n', '        totalSupply           += value;\n', '\n', '        // Activation event\n', '        ActivationRequest(msg.sender, stringToBytes32(_code));\n', '    }\n', '\n', '    /**\n', '     * @dev This is the way to refill your token balance by ethers\n', '     */\n', '    function refill() payable returns (bool) {\n', '        // Throw when over limit\n', '        if (balanceOf[msg.sender] + msg.value > limit) throw;\n', '\n', '        // Refill\n', '        balanceOf[msg.sender] += msg.value;\n', '        totalSupply           += msg.value;\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev This method is called when money sended to contract address,\n', '     *      a synonym for refill()\n', '     */\n', '    function () payable {\n', '        // Throw when over limit\n', '        if (balanceOf[msg.sender] + msg.value > limit) throw;\n', '\n', '        // Refill\n', '        balanceOf[msg.sender] += msg.value;\n', '        totalSupply           += msg.value;\n', '    }\n', '\n', '    /**\n', '     * @dev Internal transfer for AIRA\n', '     * @param _from source address\n', '     * @param _to destination address\n', '     * @param _value amount of token values to send \n', '     */\n', '    function airaTransfer(address _from, address _to, uint _value) onlyBot {\n', '        if (balanceOf[_from] >= _value) {\n', '            balanceOf[_from] -= _value;\n', '            balanceOf[_to]   += _value;\n', '            Transfer(_from, _to, _value);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Outgoing transfer for AIRA\n', '     * @param _from source address\n', '     * @param _to destination address\n', '     * @param _value amount of token values to send \n', '     */\n', '    function airaSend(address _from, address _to, uint _value) onlyBot {\n', '        if (balanceOf[_from] >= _value) {\n', '            balanceOf[_from] -= _value;\n', '            totalSupply      -= _value;\n', '            Transfer(_from, _to, _value);\n', '            if (!_to.send(_value)) throw;\n', '        }\n', '    }\n', '}']