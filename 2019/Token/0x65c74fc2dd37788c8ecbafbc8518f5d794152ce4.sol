['pragma solidity ^0.5.9;\n', '\n', 'library SafeMath\n', '{\n', '  \tfunction mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '    \t{\n', '\t\tuint256 c = a * b;\n', '\t\tassert(a == 0 || c / a == b);\n', '\n', '\t\treturn c;\n', '  \t}\n', '\n', '  \tfunction div(uint256 a, uint256 b) internal pure returns (uint256)\n', '\t{\n', '\t\tuint256 c = a / b;\n', '\n', '\t\treturn c;\n', '  \t}\n', '\n', '  \tfunction sub(uint256 a, uint256 b) internal pure returns (uint256)\n', '\t{\n', '\t\tassert(b <= a);\n', '\n', '\t\treturn a - b;\n', '  \t}\n', '\n', '  \tfunction add(uint256 a, uint256 b) internal pure returns (uint256)\n', '\t{\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\n', '\t\treturn c;\n', '  \t}\n', '}\n', '\n', 'contract OwnerHelper\n', '{\n', '  \taddress public owner;\n', '\n', '  \tevent ChangeOwner(address indexed _from, address indexed _to);\n', '\n', '  \tmodifier onlyOwner\n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '  \t}\n', '  \t\n', '  \tconstructor() public\n', '\t{\n', '\t\towner = msg.sender;\n', '  \t}\n', '  \t\n', '  \tfunction transferOwnership(address _to) onlyOwner public\n', '  \t{\n', '    \trequire(_to != owner);\n', '    \trequire(_to != address(0x0));\n', '\n', '        address from = owner;\n', '      \towner = _to;\n', '  \t    \n', '      \temit ChangeOwner(from, _to);\n', '  \t}\n', '}\n', '\n', 'contract ERC20Interface\n', '{\n', '    event Transfer( address indexed _from, address indexed _to, uint _value);\n', '    event Approval( address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '    function totalSupply() view public returns (uint _supply);\n', '    function balanceOf( address _who ) public view returns (uint _value);\n', '    function transfer( address _to, uint _value) public returns (bool _success);\n', '    function approve( address _spender, uint _value ) public returns (bool _success);\n', '    function allowance( address _owner, address _spender ) public view returns (uint _allowance);\n', '    function transferFrom( address _from, address _to, uint _value) public returns (bool _success);\n', '}\n', '\n', 'contract LINIXToken is ERC20Interface, OwnerHelper\n', '{\n', '    using SafeMath for uint;\n', '    \n', '    string public name;\n', '    uint public decimals;\n', '    string public symbol;\n', '    \n', '    uint constant private E18 = 1000000000000000000;\n', '    uint constant private month = 2592000;\n', '    \n', '    // Total                                        2,473,750,000\n', '    uint constant public maxTotalSupply =           2473750000 * E18;\n', '    \n', '    // Team                                          247,375,000 (10%)\n', '    uint constant public maxTeamSupply =             247375000 * E18;\n', '    // - 3 months after Vesting 24 times\n', '    \n', '    // R&D                                           247,375,000 (10%)\n', '    uint constant public maxRnDSupply =              247375000 * E18;\n', '    // - 2 months after Vesting 18 times\n', '    \n', '    // EcoSystem                                     371,062,500 (15%)\n', '    uint constant public maxEcoSupply =              371062500 * E18;\n', '    // - 3 months after Vesting 12 times\n', '    \n', '    // Marketing                                     197,900,000 (8%)\n', '    uint constant public maxMktSupply =              197900000 * E18;\n', '    // - 1 months after Vesting 1 time\n', '    \n', '    // Reserve                                       296,850,000 (12%)\n', '    uint constant public maxReserveSupply =          296850000 * E18;\n', '    // - Vesting 7 times\n', '    \n', '    // Advisor                                       123,687,500 (5%)\n', '    uint constant public maxAdvisorSupply =          123687500 * E18;\n', '    \n', '    // Sale Supply                                   989,500,000 (40%)\n', '    uint constant public maxSaleSupply =             989500000 * E18;\n', '    \n', '    uint constant public publicSaleSupply =          100000000 * E18;\n', '    uint constant public privateSaleSupply =         889500000 * E18;\n', '    \n', '    // Lock\n', '    uint constant public rndVestingSupply           = 9895000 * E18;\n', '    uint constant public rndVestingTime = 25;\n', '    \n', '    uint constant public teamVestingSupply          = 247375000 * E18;\n', '    uint constant public teamVestingLockDate        = 24 * month;\n', '\n', '    uint constant public advisorVestingSupply          = 30921875 * E18;\n', '    uint constant public advisorVestingLockDate        = 3 * month;\n', '    uint constant public advisorVestingTime = 4;\n', '    \n', '    uint public totalTokenSupply;\n', '    uint public tokenIssuedTeam;\n', '    uint public tokenIssuedRnD;\n', '    uint public tokenIssuedEco;\n', '    uint public tokenIssuedMkt;\n', '    uint public tokenIssuedRsv;\n', '    uint public tokenIssuedAdv;\n', '    uint public tokenIssuedSale;\n', '    \n', '    uint public burnTokenSupply;\n', '    \n', '    mapping (address => uint) public balances;\n', '    mapping (address => mapping ( address => uint )) public approvals;\n', '    \n', '    uint public teamVestingTime;\n', '    \n', '    mapping (uint => uint) public rndVestingTimer;\n', '    mapping (uint => uint) public rndVestingBalances;\n', '    \n', '    mapping (uint => uint) public advVestingTimer;\n', '    mapping (uint => uint) public advVestingBalances;\n', '    \n', '    bool public tokenLock = true;\n', '    bool public saleTime = true;\n', '    uint public endSaleTime = 0;\n', '    \n', '    event TeamIssue(address indexed _to, uint _tokens);\n', '    event RnDIssue(address indexed _to, uint _tokens);\n', '    event EcoIssue(address indexed _to, uint _tokens);\n', '    event MktIssue(address indexed _to, uint _tokens);\n', '    event RsvIssue(address indexed _to, uint _tokens);\n', '    event AdvIssue(address indexed _to, uint _tokens);\n', '    event SaleIssue(address indexed _to, uint _tokens);\n', '    \n', '    event Burn(address indexed _from, uint _tokens);\n', '    \n', '    event TokenUnlock(address indexed _to, uint _tokens);\n', '    event EndSale(uint _date);\n', '    \n', '    constructor() public\n', '    {\n', '        name        = "LNX Protocol";\n', '        decimals    = 18;\n', '        symbol      = "LNX";\n', '        \n', '        totalTokenSupply    = 0;\n', '        \n', '        tokenIssuedTeam   = 0;\n', '        tokenIssuedRnD      = 0;\n', '        tokenIssuedEco     = 0;\n', '        tokenIssuedMkt      = 0;\n', '        tokenIssuedRsv    = 0;\n', '        tokenIssuedAdv    = 0;\n', '        tokenIssuedSale     = 0;\n', '\n', '        burnTokenSupply     = 0;\n', '        \n', '        require(maxTeamSupply == teamVestingSupply);\n', '        require(maxRnDSupply == rndVestingSupply.mul(rndVestingTime));\n', '        require(maxAdvisorSupply == advisorVestingSupply.mul(advisorVestingTime));\n', '\n', '        require(maxSaleSupply == publicSaleSupply + privateSaleSupply);\n', '        require(maxTotalSupply == maxTeamSupply + maxRnDSupply + maxEcoSupply + maxMktSupply + maxReserveSupply + maxAdvisorSupply + maxSaleSupply);\n', '    }\n', '    \n', '    // ERC - 20 Interface -----\n', '\n', '    function totalSupply() view public returns (uint) \n', '    {\n', '        return totalTokenSupply;\n', '    }\n', '    \n', '    function balanceOf(address _who) view public returns (uint) \n', '    {\n', '        return balances[_who];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) public returns (bool) \n', '    {\n', '        require(isTransferable() == true);\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) public returns (bool)\n', '    {\n', '        require(isTransferable() == true);\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        approvals[msg.sender][_spender] = _value;\n', '        \n', '        emit Approval(msg.sender, _spender, _value);\n', '        \n', '        return true; \n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) view public returns (uint) \n', '    {\n', '        return approvals[_owner][_spender];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool) \n', '    {\n', '        require(isTransferable() == true);\n', '        require(balances[_from] >= _value);\n', '        require(approvals[_from][msg.sender] >= _value);\n', '        \n', '        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to]  = balances[_to].add(_value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    // -----\n', '    \n', '    // Vesting Function -----\n', '    \n', '    function teamIssue(address _to) onlyOwner public\n', '    {\n', '        require(saleTime == false);\n', '        \n', '        uint nowTime = now;\n', '        require(nowTime > teamVestingTime);\n', '        \n', '        uint tokens = teamVestingSupply;\n', '\n', '        require(maxTeamSupply >= tokenIssuedTeam.add(tokens));\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedTeam = tokenIssuedTeam.add(tokens);\n', '        \n', '        emit TeamIssue(_to, tokens);\n', '    }\n', '    \n', '    // _time : 0 ~ 24\n', '    function rndIssue(address _to, uint _time) onlyOwner public\n', '    {\n', '        require(saleTime == false);\n', '        require(_time < rndVestingTime);\n', '        \n', '        uint nowTime = now;\n', '        require( nowTime > rndVestingTimer[_time] );\n', '        \n', '        uint tokens = rndVestingSupply;\n', '\n', '        require(tokens == rndVestingBalances[_time]);\n', '        require(maxRnDSupply >= tokenIssuedRnD.add(tokens));\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        rndVestingBalances[_time] = 0;\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedRnD = tokenIssuedRnD.add(tokens);\n', '        \n', '        emit RnDIssue(_to, tokens);\n', '    }\n', '    \n', '    // _time : 0 ~ 3\n', '    function advisorIssue(address _to, uint _time) onlyOwner public\n', '    {\n', '        require(saleTime == false);\n', '        require( _time < advisorVestingTime);\n', '        \n', '        uint nowTime = now;\n', '        require( nowTime > advVestingTimer[_time] );\n', '        \n', '        uint tokens = advisorVestingSupply;\n', '\n', '        require(tokens == advVestingBalances[_time]);\n', '        require(maxAdvisorSupply >= tokenIssuedAdv.add(tokens));\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        advVestingBalances[_time] = 0;\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedAdv = tokenIssuedAdv.add(tokens);\n', '        \n', '        emit AdvIssue(_to, tokens);\n', '    }\n', '    \n', '    function ecoIssue(address _to) onlyOwner public\n', '    {\n', '        require(saleTime == false);\n', '        require(tokenIssuedEco == 0);\n', '        \n', '        uint tokens = maxEcoSupply;\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedEco = tokenIssuedEco.add(tokens);\n', '        \n', '        emit EcoIssue(_to, tokens);\n', '    }\n', '    \n', '    function mktIssue(address _to) onlyOwner public\n', '    {\n', '        require(saleTime == false);\n', '        require(tokenIssuedMkt == 0);\n', '        \n', '        uint tokens = maxMktSupply;\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedMkt = tokenIssuedMkt.add(tokens);\n', '        \n', '        emit EcoIssue(_to, tokens);\n', '    }\n', '    \n', '    function rsvIssue(address _to) onlyOwner public\n', '    {\n', '        require(saleTime == false);\n', '        require(tokenIssuedRsv == 0);\n', '        \n', '        uint tokens = maxReserveSupply;\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedRsv = tokenIssuedRsv.add(tokens);\n', '        \n', '        emit EcoIssue(_to, tokens);\n', '    }\n', '    \n', '    function privateSaleIssue(address _to) onlyOwner public\n', '    {\n', '        require(tokenIssuedSale == 0);\n', '        \n', '        uint tokens = privateSaleSupply;\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedSale = tokenIssuedSale.add(tokens);\n', '        \n', '        emit SaleIssue(_to, tokens);\n', '    }\n', '    \n', '    function publicSaleIssue(address _to) onlyOwner public\n', '    {\n', '        require(tokenIssuedSale == privateSaleSupply);\n', '        \n', '        uint tokens = publicSaleSupply;\n', '        \n', '        balances[_to] = balances[_to].add(tokens);\n', '        \n', '        totalTokenSupply = totalTokenSupply.add(tokens);\n', '        tokenIssuedSale = tokenIssuedSale.add(tokens);\n', '        \n', '        emit SaleIssue(_to, tokens);\n', '    }\n', '    \n', '    // -----\n', '    \n', '    // Lock Function -----\n', '    \n', '    function isTransferable() private view returns (bool)\n', '    {\n', '        if(tokenLock == false)\n', '        {\n', '            return true;\n', '        }\n', '        else if(msg.sender == owner)\n', '        {\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '    \n', '    function setTokenUnlock() onlyOwner public\n', '    {\n', '        require(tokenLock == true);\n', '        require(saleTime == false);\n', '        \n', '        tokenLock = false;\n', '    }\n', '    \n', '    function setTokenLock() onlyOwner public\n', '    {\n', '        require(tokenLock == false);\n', '        \n', '        tokenLock = true;\n', '    }\n', '    \n', '    // -----\n', '    \n', '    // ETC / Burn Function -----\n', '    \n', '    function endSale() onlyOwner public\n', '    {\n', '        require(saleTime == true);\n', '        require(maxSaleSupply == tokenIssuedSale);\n', '        \n', '        saleTime = false;\n', '        \n', '        uint nowTime = now;\n', '        endSaleTime = nowTime;\n', '        \n', '        teamVestingTime = endSaleTime + teamVestingLockDate;\n', '        \n', '        for(uint i = 0; i < rndVestingTime; i++)\n', '        {\n', '            rndVestingTimer[i] =  endSaleTime + (month * i);\n', '            rndVestingBalances[i] = rndVestingSupply;\n', '        }\n', '        \n', '        for(uint i = 0; i < advisorVestingTime; i++)\n', '        {\n', '            advVestingTimer[i] = endSaleTime + (advisorVestingLockDate * i);\n', '            advVestingBalances[i] = advisorVestingSupply;\n', '        }\n', '        \n', '        emit EndSale(endSaleTime);\n', '    }\n', '    \n', '    function withdrawTokens(address _contract, uint _decimals, uint _value) onlyOwner public\n', '    {\n', '\n', '        if(_contract == address(0x0))\n', '        {\n', '            uint eth = _value.mul(10 ** _decimals);\n', '            msg.sender.transfer(eth);\n', '        }\n', '        else\n', '        {\n', '            uint tokens = _value.mul(10 ** _decimals);\n', '            ERC20Interface(_contract).transfer(msg.sender, tokens);\n', '            \n', '            emit Transfer(address(0x0), msg.sender, tokens);\n', '        }\n', '    }\n', '    \n', '    function burnToken(uint _value) onlyOwner public\n', '    {\n', '        uint tokens = _value * E18;\n', '        \n', '        require(balances[msg.sender] >= tokens);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        \n', '        burnTokenSupply = burnTokenSupply.add(tokens);\n', '        totalTokenSupply = totalTokenSupply.sub(tokens);\n', '        \n', '        emit Burn(msg.sender, tokens);\n', '    }\n', '    \n', '    function close() onlyOwner public\n', '    {\n', '        selfdestruct(msg.sender);\n', '    }\n', '    \n', '    // -----\n', '}']