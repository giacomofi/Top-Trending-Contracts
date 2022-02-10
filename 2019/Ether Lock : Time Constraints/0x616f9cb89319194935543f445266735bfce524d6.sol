['pragma solidity ^0.4.17;\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract owlockups {\n', '    using SafeMath for uint;\n', '    \n', '    string public symbol = "OWTL";\n', '    uint256 public decimals = 18;\n', '    uint256 public totalSupply;\n', '    uint256 public totalAvailable;\n', '    uint public totalAddress;\n', '    \n', '    \n', '    address public admin;\n', '    uint public _lockupBaseTime = 1 days;\n', '    address public tokenAddress;\n', '    \n', '    modifier onlyOwner {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '    \n', '    mapping ( address => uint256 ) public balanceOf;\n', '    mapping ( address => lockupMeta ) public lockups;\n', '    \n', '    struct lockupMeta {\n', '        uint256 amount;\n', '        uint256 cycle_amount;\n', '        uint cycle;\n', '        uint claimed_cycle;\n', '        uint duration;\n', '        uint last_withdraw;\n', '        bool active;\n', '        bool claimed;\n', '        uint time;\n', '    }\n', '    \n', '    function owlockups(address _address) public {\n', '        tokenAddress = _address;\n', '        admin = msg.sender;\n', '    }\n', '    \n', '    function setAdmin(address _newAdmin) public onlyOwner {\n', '        admin = _newAdmin;\n', '    }\n', '    \n', '    function lockTokens(\n', '        address _address, \n', '        uint256 _value, \n', '        uint _percentage, \n', '        uint _duration, \n', '        uint _cycle\n', '    ) public onlyOwner returns (bool success) {\n', '        _value =  _value * 10**uint(decimals);\n', '        lockupMeta storage lm = lockups[_address];\n', '        require(!lm.active);\n', '        \n', '        uint256 _amount = (_value.mul(_percentage)).div(100);\n', '        uint256 _remaining = _value.sub(_amount);\n', '        uint256 _cycle_amount = _remaining.div(_cycle);\n', '        \n', '        lm.amount = _remaining;\n', '        lm.duration = _duration * _lockupBaseTime;\n', '        lm.cycle_amount = _cycle_amount;\n', '        lm.cycle = _cycle;\n', '        lm.active = true;\n', '        lm.last_withdraw = now;\n', '        lm.time = now;\n', '        \n', '        totalAddress++;\n', '        totalSupply = totalSupply.add(_value);\n', '        totalAvailable = totalAvailable.add(_amount);\n', '        balanceOf[_address] = balanceOf[_address].add(_amount);\n', '        \n', '        success = true;\n', '    }\n', '    \n', '    function unlockTokens() public returns (bool success) {\n', '        lockupMeta storage lm = lockups[msg.sender];\n', '        require(\n', '            lm.active \n', '            && !lm.claimed\n', '        );\n', '        \n', '        uint _curTime = now;\n', '        uint _diffTime = _curTime.sub(lm.last_withdraw);\n', '        uint _cycles = (_diffTime.div(_lockupBaseTime));\n', '        \n', '        if(_cycles >= 1){\n', '            uint remaining_cycle = lm.cycle.sub(lm.claimed_cycle);\n', '            uint256 _amount = 0;\n', '            if(_cycles > remaining_cycle){\n', '                _amount = lm.cycle_amount * remaining_cycle;\n', '                lm.claimed_cycle = lm.cycle;\n', '                lm.last_withdraw = _curTime;\n', '            } else {\n', '                _amount = lm.cycle_amount * _cycles;\n', '                lm.claimed_cycle = lm.claimed_cycle.add(_cycles);\n', '                lm.last_withdraw = lm.last_withdraw.add(_cycles.mul(lm.duration));\n', '            }\n', '            \n', '            if(lm.claimed_cycle == lm.cycle){\n', '                lm.claimed = true;\n', '            }\n', '            \n', '            totalAvailable = totalAvailable.add(_amount);\n', '            balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);\n', '            \n', '            success = true;\n', '            \n', '        } else {\n', '            success = false;\n', '        }\n', '    }\n', '    \n', '    function availableTokens(address _address) public view returns (uint256 _amount) {\n', '        lockupMeta storage lm = lockups[_address];\n', '        \n', '        _amount = 0;\n', '        \n', '        if(lm.active && !lm.claimed){\n', '            uint _curTime = now;\n', '            uint _diffTime = _curTime.sub(lm.last_withdraw);\n', '            uint _cycles = (_diffTime.div(_lockupBaseTime));\n', '            \n', '            if(_cycles >= 1){\n', '                uint remaining_cycle = lm.cycle.sub(lm.claimed_cycle);\n', '                \n', '                if(_cycles > remaining_cycle){\n', '                    _amount = lm.cycle_amount * remaining_cycle;\n', '                } else {\n', '                    _amount = lm.cycle_amount * _cycles;\n', '                }\n', '                \n', '            }\n', '        }\n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(\n', '            _value > 0\n', '            && balanceOf[msg.sender] >= _value\n', '        );\n', '        \n', '        totalSupply = totalSupply.sub(_value);\n', '        totalAvailable = totalAvailable.sub(_value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        ERC20(tokenAddress).transfer(_to, _value);\n', '        \n', '        return true;\n', '    }\n', '}']