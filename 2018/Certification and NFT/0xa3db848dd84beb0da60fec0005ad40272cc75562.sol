['// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ODIN token contract \n', '// ----------------------------------------------------------------------------\n', 'pragma solidity ^0.4.21;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address private newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract OdinToken is ERC20Interface, Owned {\n', '\n', '  using SafeMath for uint256;\n', '\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint private _totalSupply;\n', '    bool private _whitelistAll;\n', '\n', '    struct balanceData {  \n', '       bool locked;\n', '       uint balance;\n', '       uint airDropQty;\n', '    }\n', '\n', '    mapping(address => balanceData) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '\n', '  /**\n', '  * @dev Constructor for Odin creation\n', '  * @dev Initially assigns the totalSupply to the contract creator\n', '  */\n', '    function OdinToken() public {\n', '        \n', '        // owner of this contract\n', '        address owner;\n', '        owner = msg.sender;\n', '        symbol = "ODIN";\n', '        name = "ODIN Token";\n', '        decimals = 18;\n', '        _whitelistAll=false;\n', '        _totalSupply = 100000000000000000000000;\n', '        balances[owner].balance = _totalSupply;\n', '\n', '        Transfer(address(0), msg.sender, _totalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply - balances[owner].balance;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // whitelist an address\n', '    // ------------------------------------------------------------------------\n', '    function whitelistAddress(address to) public returns (bool)    {\n', '\t\trequire(msg.sender == owner);\n', '\t\tbalances[to].airDropQty = 0;\n', '\t\treturn true;\n', '    }\n', '\n', '\n', '  /**\n', '  * @dev Whitelist all addresses early\n', '  * @return An bool showing if the function succeeded.\n', '  */\n', '    function whitelistAllAddresses() public returns (bool) {\n', '        require (msg.sender == owner);\n', '        _whitelistAll = true;\n', '        return true;\n', '    }\n', '\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param tokenOwner The address to query the the balance of.\n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner].balance;\n', '    }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param tokens The amount to be transferred.\n', '  */\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '\n', '        require (msg.sender != to);                             // cannot send to yourself\n', '        require(to != address(0));                              // cannot send to address(0)\n', '        require(tokens <= balances[msg.sender].balance);        // do you have enough to send?\n', '        \n', '        uint sep_1_2018_ts = 1535760000;\n', '        uint dec_31_2018_ts = 1546214400;\n', '        uint mar_31_2019_ts = 1553990400;\n', '        uint jun_30_2019_ts = 1561852800;\n', '        uint oct_2_2019_ts = 1569974400;\n', '\n', '        if (!_whitelistAll) {\n', '\n', '            // do not allow transfering air dropped tokens prior to Sep 1 2018\n', '             if (msg.sender != owner && block.timestamp < sep_1_2018_ts && balances[msg.sender].airDropQty>0) {\n', '                 require(tokens < 0);\n', '            }\n', '\n', '            // after Sep 1 2018 and before Dec 31, 2018, do not allow transfering more than 10% of air dropped tokens\n', '            if (msg.sender != owner && block.timestamp < dec_31_2018_ts && balances[msg.sender].airDropQty>0) {\n', '                require((balances[msg.sender].balance - tokens) >= (balances[msg.sender].airDropQty / 10 * 9));\n', '            }\n', '\n', '            // after Dec 31 2018 and before March 31, 2019, do not allow transfering more than 25% of air dropped tokens\n', '            if (msg.sender != owner && block.timestamp < mar_31_2019_ts && balances[msg.sender].airDropQty>0) {\n', '                require((balances[msg.sender].balance - tokens) >= balances[msg.sender].airDropQty / 4 * 3);\n', '            }\n', '\n', '            // after March 31, 2019 and before Jun 30, 2019, do not allow transfering more than 50% of air dropped tokens\n', '            if (msg.sender != owner && block.timestamp < jun_30_2019_ts && balances[msg.sender].airDropQty>0) {\n', '                require((balances[msg.sender].balance - tokens) >= balances[msg.sender].airDropQty / 2);\n', '            }\n', '\n', '            // after Jun 30, 2019 and before Oct 2, 2019, do not allow transfering more than 75% of air dropped tokens\n', '            if (msg.sender != owner && block.timestamp < jun_30_2019_ts && balances[msg.sender].airDropQty>0) {\n', '                require((balances[msg.sender].balance - tokens) >= balances[msg.sender].airDropQty / 4);\n', '            }\n', '            \n', '            // otherwise, no transfer restrictions\n', '\n', '        }\n', '        \n', '        balances[msg.sender].balance = balances[msg.sender].balance.sub(tokens);\n', '        balances[to].balance = balances[to].balance.add(tokens);\n', '        if (msg.sender == owner) {\n', '            balances[to].airDropQty = balances[to].airDropQty.add(tokens);\n', '        }\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // not implemented\n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        return false;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // not implemented\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        return false;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // not implemented\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return 0;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // not implemented\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        return false;\n', '    }\n', '\n', '    function () {\n', '        //if ether is sent to this address, send it back.\n', '        throw;\n', '    }\n', '}']