['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ptc {\n', '    function balanceOf(address _owner) constant public returns (uint256);\n', '}\n', '\n', 'contract Jade {\n', '    using SafeMath for uint256;\n', '    /* Public variables of the token */\n', '    uint256 public totalSupply;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 3;\n', '    uint256 public totalMember;\n', '\n', '    uint256 private tickets = 50*(10**18);\n', '    uint256 private max_level = 20;\n', '    uint256 private ajust_time = 30*24*60*60;\n', '    uint256 private min_interval = (24*60*60 - 30*60);\n', '    uint256 private creation_time;\n', '\n', '    /* This creates an array with all balances */\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => uint256) public levels;\n', '\n', '    mapping (address => uint256) private last_mine_time;\n', '\n', '    /* This generates a public event on the blockchain that will notify clients */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    address private ptc_addr = 0xeCa906474016f727D1C2Ec096046C03eAc4Aa085;\n', '    Ptc ptc_ins = Ptc(ptc_addr);\n', '\n', '    constructor(string _name, string _symbol) public{\n', '        totalSupply = 0;\n', '        totalMember = 0;\n', '        creation_time = now;\n', '        name = _name;\n', '        symbol = _symbol;\n', '    }\n', '\n', '    // all call_func from msg.sender must at least have 50 ptc coins\n', '    modifier only_ptc_owner {\n', '        require(ptc_ins.balanceOf(msg.sender) >= tickets);\n', '        _;\n', '    }\n', '\n', '    /* Send coins */\n', '    function transfer(address _to, uint256 _value) public only_ptc_owner{\n', '        /* if the sender doenst have enough balance then stop */\n', '        require (balanceOf[msg.sender] >= _value);\n', '        require (balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '        /* Add and subtract new balances */\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '\n', '        /* Notifiy anyone listening that this transfer took place */\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function ptc_balance(address addr) constant public returns(uint256){\n', '        return ptc_ins.balanceOf(addr);\n', '    }\n', '\n', '    function rest_time() constant public only_ptc_owner returns(uint256) {\n', '        if (now >= last_mine_time[msg.sender].add(min_interval))\n', '            return 0;\n', '        else\n', '            return last_mine_time[msg.sender].add(min_interval).sub(now);\n', '    }\n', '\n', '    function catch_the_thief(address check_addr) public only_ptc_owner returns(bool){\n', '        if (ptc_ins.balanceOf(check_addr) < tickets) {\n', '            levels[msg.sender] = levels[msg.sender].add(levels[check_addr]);\n', '            update_power();\n', '\n', '            balanceOf[check_addr] = 0;\n', '            levels[check_addr] = 0;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function mine_jade() public only_ptc_owner returns(uint256) {\n', '        if (last_mine_time[msg.sender] == 0) {\n', '            last_mine_time[msg.sender] = now;\n', '            update_power();\n', '\n', '            balanceOf[msg.sender] = mine_jade_ex(levels[msg.sender]);\n', '            totalSupply = totalSupply.add(mine_jade_ex(levels[msg.sender]));\n', '            totalMember = totalMember.add(1);\n', '\n', '            return mine_jade_ex(levels[msg.sender]);\n', '        } else if (now >= last_mine_time[msg.sender].add(min_interval)) {\n', '            last_mine_time[msg.sender] = now;\n', '            update_power();\n', '\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].add(mine_jade_ex(levels[msg.sender]));\n', '            totalSupply = totalSupply.add(mine_jade_ex(levels[msg.sender]));\n', '\n', '            return mine_jade_ex(levels[msg.sender]);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function mine_jade_ex(uint256 power) private view returns(uint256) {\n', '        uint256 cycle = now.sub(creation_time).div(ajust_time);\n', '        require (cycle >= 0);\n', '        require (power >= 0);\n', '        require (power <= max_level);\n', '\n', '        return ((100*power + 20*(power**2)).mul(95**cycle)).div(100**cycle);\n', '    }\n', '\n', '    function update_power() private {\n', '        require (levels[msg.sender] >= 0);\n', '        if (levels[msg.sender] < max_level)\n', '            levels[msg.sender] = levels[msg.sender].add(1);\n', '        else\n', '            levels[msg.sender] = max_level;\n', '    }\n', '}']