['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '//共识会 contract\n', '//\n', '//共识勋章：象征着你在共识会的地位和权利\n', '//Anno Consensus Medal: Veni, Vidi, Vici\n', '// \n', '// Symbol      : CPLD\n', '// Name        : Anno Consensus Medal\n', '// Total supply: 1000000\n', '// Decimals    : 0\n', '// \n', '// 共识币：维护共识新纪元的基石\n', '//Anno Consensus Coin: Caput, Anguli, Seclorum\n', '// Symbol      : anno\n', '// Name        : Anno Consensus Token\n', '// Total supply: 1000000000\n', '// Decimals    : 18\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) public pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) public pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) public pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) public pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Admin contract\n', '// ----------------------------------------------------------------------------\n', 'contract Administration {\n', '    event AdminTransferred(address indexed _from, address indexed _to);\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    address public adminAddress = 0xbd74Dec00Af1E745A21d5130928CD610BE963027;\n', '\n', '    bool public paused = false;\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == adminAddress);\n', '        _;\n', '    }\n', '\n', '    function setAdmin(address _newAdmin) public onlyAdmin {\n', '        require(_newAdmin != address(0));\n', '        AdminTransferred(adminAddress, _newAdmin);\n', '        adminAddress = _newAdmin;\n', '        \n', '    }\n', '\n', '    function withdrawBalance() external onlyAdmin {\n', '        adminAddress.transfer(this.balance);\n', '    }\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyAdmin whenNotPaused returns(bool) {\n', '        paused = true;\n', '        Pause();\n', '        return true;\n', '    }\n', '\n', '    function unpause() public onlyAdmin whenPaused returns(bool) {\n', '        paused = false;\n', '        Unpause();\n', '        return true;\n', '    }\n', '\n', '    uint oneEth = 1 ether;\n', '}\n', '\n', 'contract AnnoMedal is ERC20Interface, Administration, SafeMath {\n', '    event MedalTransfer(address indexed from, address indexed to, uint tokens);\n', '    \n', '    string public medalSymbol;\n', '    string public medalName;\n', '    uint8 public medalDecimals;\n', '    uint public _medalTotalSupply;\n', '\n', '    mapping(address => uint) medalBalances;\n', '    mapping(address => bool) medalFreezed;\n', '    mapping(address => uint) medalFreezeAmount;\n', '    mapping(address => uint) medalUnlockTime;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function AnnoMedal() public {\n', '        medalSymbol = "ANCM";\n', '        medalName = "Anno Consensus Medal";\n', '        medalDecimals = 0;\n', '        _medalTotalSupply = 1000000;\n', '        medalBalances[adminAddress] = _medalTotalSupply;\n', '        MedalTransfer(address(0), adminAddress, _medalTotalSupply);\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function medalTotalSupply() public constant returns (uint) {\n', '        return _medalTotalSupply  - medalBalances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function medalBalanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return medalBalances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to to account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function medalTransfer(address to, uint tokens) public whenNotPaused returns (bool success) {\n', '        if(medalFreezed[msg.sender] == false){\n', '            medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], tokens);\n', '            medalBalances[to] = safeAdd(medalBalances[to], tokens);\n', '            MedalTransfer(msg.sender, to, tokens);\n', '        } else {\n', '            if(medalBalances[msg.sender] > medalFreezeAmount[msg.sender]) {\n', '                require(tokens <= safeSub(medalBalances[msg.sender], medalFreezeAmount[msg.sender]));\n', '                medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], tokens);\n', '                medalBalances[to] = safeAdd(medalBalances[to], tokens);\n', '                MedalTransfer(msg.sender, to, tokens);\n', '            }\n', '        }\n', '            \n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Mint Tokens\n', '    // ------------------------------------------------------------------------\n', '    function mintMedal(uint amount) public onlyAdmin {\n', '        medalBalances[msg.sender] = safeAdd(medalBalances[msg.sender], amount);\n', '        _medalTotalSupply = safeAdd(_medalTotalSupply, amount);\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Burn Tokens\n', '    // ------------------------------------------------------------------------\n', '    function burnMedal(uint amount) public onlyAdmin {\n', '        medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], amount);\n', '        _medalTotalSupply = safeSub(_medalTotalSupply, amount);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Freeze Tokens\n', '    // ------------------------------------------------------------------------\n', '    function medalFreeze(address user, uint amount, uint period) public onlyAdmin {\n', '        require(medalBalances[user] >= amount);\n', '        medalFreezed[user] = true;\n', '        medalUnlockTime[user] = uint(now) + period;\n', '        medalFreezeAmount[user] = amount;\n', '    }\n', '    \n', '    function _medalFreeze(uint amount) internal {\n', '        require(medalFreezed[msg.sender] == false);\n', '        require(medalBalances[msg.sender] >= amount);\n', '        medalFreezed[msg.sender] = true;\n', '        medalUnlockTime[msg.sender] = uint(-1);\n', '        medalFreezeAmount[msg.sender] = amount;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // UnFreeze Tokens\n', '    // ------------------------------------------------------------------------\n', '    function medalUnFreeze() public whenNotPaused {\n', '        require(medalFreezed[msg.sender] == true);\n', '        require(medalUnlockTime[msg.sender] < uint(now));\n', '        medalFreezed[msg.sender] = false;\n', '        medalFreezeAmount[msg.sender] = 0;\n', '    }\n', '    \n', '    function _medalUnFreeze(uint _amount) internal {\n', '        require(medalFreezed[msg.sender] == true);\n', '        medalUnlockTime[msg.sender] = 0;\n', '        medalFreezed[msg.sender] = false;\n', '        medalFreezeAmount[msg.sender] = safeSub(medalFreezeAmount[msg.sender], _amount);\n', '    }\n', '    \n', '    function medalIfFreeze(address user) public view returns (\n', '        bool check, \n', '        uint amount, \n', '        uint timeLeft\n', '    ) {\n', '        check = medalFreezed[user];\n', '        amount = medalFreezeAmount[user];\n', '        timeLeft = medalUnlockTime[user] - uint(now);\n', '    }\n', '\n', '}\n', '\n', 'contract AnnoToken is AnnoMedal {\n', '    event PartnerCreated(uint indexed partnerId, address indexed partner, uint indexed amount, uint singleTrans, uint durance);\n', '    event RewardDistribute(uint indexed postId, uint partnerId, address indexed user, uint indexed amount);\n', '    \n', '    event VipAgreementSign(uint indexed vipId, address indexed vip, uint durance, uint frequence, uint salar);\n', '    event SalaryReceived(uint indexed vipId, address indexed vip, uint salary, uint indexed timestamp);\n', '    \n', '    string public symbol;\n', '    string public  name;\n', '    uint8 public decimals;\n', '    uint public _totalSupply;\n', '    uint public minePool;\n', '\n', '    struct Partner {\n', '        address admin;\n', '        uint tokenPool;\n', '        uint singleTrans;\n', '        uint timestamp;\n', '        uint durance;\n', '    }\n', '    \n', '    struct Poster {\n', '        address poster;\n', '        bytes32 hashData;\n', '        uint reward;\n', '    }\n', '    \n', '    struct Vip {\n', '        address vip;\n', '        uint durance;\n', '        uint frequence;\n', '        uint salary;\n', '        uint timestamp;\n', '    }\n', '    \n', '    Partner[] partners;\n', '    Vip[] vips;\n', '\n', '    modifier onlyPartner(uint _partnerId) {\n', '        require(partners[_partnerId].admin == msg.sender);\n', '        require(partners[_partnerId].tokenPool > uint(0));\n', '        uint deadline = safeAdd(partners[_partnerId].timestamp, partners[_partnerId].durance);\n', '        require(deadline > now);\n', '        _;\n', '    }\n', '    \n', '    modifier onlyVip(uint _vipId) {\n', '        require(vips[_vipId].vip == msg.sender);\n', '        require(vips[_vipId].durance > now);\n', '        require(vips[_vipId].timestamp < now);\n', '        _;\n', '    }\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    mapping(address => bool) freezed;\n', '    mapping(address => uint) freezeAmount;\n', '    mapping(address => uint) unlockTime;\n', '    \n', '    mapping(uint => Poster[]) PartnerIdToPosterList;\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function AnnoToken() public {\n', '        symbol = "ANOT";\n', '        name = "Anno Consensus Token";\n', '        decimals = 18;\n', '        _totalSupply = 1000000000000000000000000000;\n', '        minePool = 600000000000000000000000000;\n', '        balances[adminAddress] = _totalSupply - minePool;\n', '        Transfer(address(0), adminAddress, _totalSupply);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return _totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account tokenOwner\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to to account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public returns (bool success) {\n', '        if(freezed[msg.sender] == false){\n', '            balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '            balances[to] = safeAdd(balances[to], tokens);\n', '            Transfer(msg.sender, to, tokens);\n', '        } else {\n', '            if(balances[msg.sender] > freezeAmount[msg.sender]) {\n', '                require(tokens <= safeSub(balances[msg.sender], freezeAmount[msg.sender]));\n', '                balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '                balances[to] = safeAdd(balances[to], tokens);\n', '                Transfer(msg.sender, to, tokens);\n', '            }\n', '        }\n', '            \n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public returns (bool success) {\n', '        require(freezed[msg.sender] != true);\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer tokens from the from account to the to account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the from account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        require(freezed[msg.sender] != true);\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for spender to transferFrom(...) tokens\n', '    // from the token owner&#39;s account. The spender contract function\n', '    // receiveApproval(...) is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        require(freezed[msg.sender] != true);\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Mint Tokens\n', '    // ------------------------------------------------------------------------\n', '    function _mint(uint amount, address receiver) internal {\n', '        require(minePool >= amount);\n', '        minePool = safeSub(minePool, amount);\n', '        balances[receiver] = safeAdd(balances[receiver], amount);\n', '        Transfer(address(0), receiver, amount);\n', '    }\n', '    \n', '    function mint(uint amount) public onlyAdmin {\n', '        require(minePool >= amount);\n', '        minePool = safeSub(minePool, amount);\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], amount);\n', '        _totalSupply = safeAdd(_totalSupply, amount);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Freeze Tokens\n', '    // ------------------------------------------------------------------------\n', '    function freeze(address user, uint amount, uint period) public onlyAdmin {\n', '        require(balances[user] >= amount);\n', '        freezed[user] = true;\n', '        unlockTime[user] = uint(now) + period;\n', '        freezeAmount[user] = amount;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // UnFreeze Tokens\n', '    // ------------------------------------------------------------------------\n', '    function unFreeze() public {\n', '        require(freezed[msg.sender] == true);\n', '        require(unlockTime[msg.sender] < uint(now));\n', '        freezed[msg.sender] = false;\n', '        freezeAmount[msg.sender] = 0;\n', '    }\n', '    \n', '    function ifFreeze(address user) public view returns (\n', '        bool check, \n', '        uint amount, \n', '        uint timeLeft\n', '    ) {\n', '        check = freezed[user];\n', '        amount = freezeAmount[user];\n', '        timeLeft = unlockTime[user] - uint(now);\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Partner Authorization\n', '    // ------------------------------------------------------------------------\n', '    function createPartner(address _partner, uint _amount, uint _singleTrans, uint _durance) public onlyAdmin returns (uint) {\n', '        Partner memory _Partner = Partner({\n', '            admin: _partner,\n', '            tokenPool: _amount,\n', '            singleTrans: _singleTrans,\n', '            timestamp: uint(now),\n', '            durance: _durance\n', '        });\n', '        uint newPartnerId = partners.push(_Partner) - 1;\n', '        PartnerCreated(newPartnerId, _partner, _amount, _singleTrans, _durance);\n', '        \n', '        return newPartnerId;\n', '    }\n', '    \n', '    function partnerTransfer(uint _partnerId, bytes32 _data, address _to, uint _amount) public onlyPartner(_partnerId) whenNotPaused returns (bool) {\n', '        require(_amount <= partners[_partnerId].singleTrans);\n', '        partners[_partnerId].tokenPool = safeSub(partners[_partnerId].tokenPool, _amount);\n', '        Poster memory _Poster = Poster ({\n', '           poster: _to,\n', '           hashData: _data,\n', '           reward: _amount\n', '        });\n', '        uint newPostId = PartnerIdToPosterList[_partnerId].push(_Poster) - 1;\n', '        _mint(_amount, _to);\n', '        RewardDistribute(newPostId, _partnerId, _to, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function setPartnerPool(uint _partnerId, uint _amount) public onlyAdmin {\n', '        partners[_partnerId].tokenPool = _amount;\n', '    }\n', '    \n', '    function setPartnerDurance(uint _partnerId, uint _durance) public onlyAdmin {\n', '        partners[_partnerId].durance = uint(now) + _durance;\n', '    }\n', '    \n', '    function getPartnerInfo(uint _partnerId) public view returns (\n', '        address admin,\n', '        uint tokenPool,\n', '        uint timeLeft\n', '    ) {\n', '        Partner memory _Partner = partners[_partnerId];\n', '        admin = _Partner.admin;\n', '        tokenPool = _Partner.tokenPool;\n', '        if (_Partner.timestamp + _Partner.durance > uint(now)) {\n', '            timeLeft = _Partner.timestamp + _Partner.durance - uint(now);\n', '        } else {\n', '            timeLeft = 0;\n', '        }\n', '        \n', '    }\n', '\n', '    function getPosterInfo(uint _partnerId, uint _posterId) public view returns (\n', '        address poster,\n', '        bytes32 hashData,\n', '        uint reward\n', '    ) {\n', '        Poster memory _Poster = PartnerIdToPosterList[_partnerId][_posterId];\n', '        poster = _Poster.poster;\n', '        hashData = _Poster.hashData;\n', '        reward = _Poster.reward;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Vip Agreement\n', '    // ------------------------------------------------------------------------\n', '    function createVip(address _vip, uint _durance, uint _frequence, uint _salary) public onlyAdmin returns (uint) {\n', '        Vip memory _Vip = Vip ({\n', '           vip: _vip,\n', '           durance: uint(now) + _durance,\n', '           frequence: _frequence,\n', '           salary: _salary,\n', '           timestamp: now + _frequence\n', '        });\n', '        uint newVipId = vips.push(_Vip) - 1;\n', '        VipAgreementSign(newVipId, _vip, _durance, _frequence, _salary);\n', '        \n', '        return newVipId;\n', '    }\n', '    \n', '    function mineSalary(uint _vipId) public onlyVip(_vipId) whenNotPaused returns (bool) {\n', '        Vip storage _Vip = vips[_vipId];\n', '        _mint(_Vip.salary, _Vip.vip);\n', '        _Vip.timestamp = safeAdd(_Vip.timestamp, _Vip.frequence);\n', '        \n', '        SalaryReceived(_vipId, _Vip.vip, _Vip.salary, _Vip.timestamp);\n', '        return true;\n', '    }\n', '    \n', '    function deleteVip(uint _vipId) public onlyAdmin {\n', '        delete vips[_vipId];\n', '    }\n', '    \n', '    function getVipInfo(uint _vipId) public view returns (\n', '        address vip,\n', '        uint durance,\n', '        uint frequence,\n', '        uint salary,\n', '        uint nextSalary,\n', '        string log\n', '    ) {\n', '        Vip memory _Vip = vips[_vipId];\n', '        vip = _Vip.vip;\n', '        durance = _Vip.durance;\n', '        frequence = _Vip.frequence;\n', '        salary = _Vip.salary;\n', '        if(_Vip.timestamp >= uint(now)) {\n', '            nextSalary = safeSub(_Vip.timestamp, uint(now));\n', '            log = "Please Wait";\n', '        } else {\n', '            nextSalary = 0;\n', '            log = "Pick Up Your Salary Now";\n', '        }\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Accept ETH\n', '    // ------------------------------------------------------------------------\n', '    function () public payable {\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(adminAddress, tokens);\n', '    }\n', '}\n', '\n', 'contract Anno is AnnoToken {\n', '    event MembershipUpdate(address indexed member, uint indexed level);\n', '    event MembershipCancel(address indexed member);\n', '    event AnnoTradeCreated(uint indexed tradeId, bool indexed ifMedal, uint medal, uint token);\n', '    event TradeCancel(uint indexed tradeId);\n', '    event TradeComplete(uint indexed tradeId, address indexed buyer, address indexed seller, uint medal, uint token);\n', '    event Mine(address indexed miner, uint indexed salary);\n', '    \n', '    mapping (address => uint) MemberToLevel;\n', '    mapping (address => uint) MemberToMedal;\n', '    mapping (address => uint) MemberToToken;\n', '    mapping (address => uint) MemberToTime;\n', '    \n', '    uint public period = 14 days;\n', '    \n', '    uint[5] public boardMember =[\n', '        0,\n', '        500,\n', '        2500,\n', '        25000,\n', '        50000\n', '    ];\n', '    \n', '    uint[5] public salary = [\n', '        0,\n', '        1151000000000000000000,\n', '        5753000000000000000000,\n', '        57534000000000000000000,\n', '        115068000000000000000000\n', '    ];\n', '    \n', '    struct AnnoTrade {\n', '        address seller;\n', '        bool ifMedal;\n', '        uint medal;\n', '        uint token;\n', '    }\n', '    \n', '    AnnoTrade[] annoTrades;\n', '    \n', '    function boardMemberApply(uint _level) public whenNotPaused {\n', '        require(_level > 0 && _level <= 4);\n', '        require(medalBalances[msg.sender] >= boardMember[_level]);\n', '        _medalFreeze(boardMember[_level]);\n', '        MemberToLevel[msg.sender] = _level;\n', '        if(MemberToTime[msg.sender] == 0) {\n', '            MemberToTime[msg.sender] = uint(now);\n', '        }\n', '        \n', '        MembershipUpdate(msg.sender, _level);\n', '    }\n', '    \n', '    function getBoardMember(address _member) public view returns (\n', '        uint level,\n', '        uint timeLeft\n', '    ) {\n', '        level = MemberToLevel[_member];\n', '        if(MemberToTime[_member] > uint(now)) {\n', '            timeLeft = safeSub(MemberToTime[_member], uint(now));\n', '        } else {\n', '            timeLeft = 0;\n', '        }\n', '    }\n', '    \n', '    function boardMemberCancel() public whenNotPaused {\n', '        require(MemberToLevel[msg.sender] > 0);\n', '        _medalUnFreeze(boardMember[MemberToLevel[msg.sender]]);\n', '        \n', '        MemberToLevel[msg.sender] = 0;\n', '        MembershipCancel(msg.sender);\n', '    }\n', '    \n', '    function createAnnoTrade(bool _ifMedal, uint _medal, uint _token) public whenNotPaused returns (uint) {\n', '        if(_ifMedal) {\n', '            require(medalBalances[msg.sender] >= _medal);\n', '            medalBalances[msg.sender] = safeSub(medalBalances[msg.sender], _medal);\n', '            MemberToMedal[msg.sender] = _medal;\n', '            AnnoTrade memory anno = AnnoTrade({\n', '               seller: msg.sender,\n', '               ifMedal:_ifMedal,\n', '               medal: _medal,\n', '               token: _token\n', '            });\n', '            uint newMedalTradeId = annoTrades.push(anno) - 1;\n', '            AnnoTradeCreated(newMedalTradeId, _ifMedal, _medal, _token);\n', '            \n', '            return newMedalTradeId;\n', '        } else {\n', '            require(balances[msg.sender] >= _token);\n', '            balances[msg.sender] = safeSub(balances[msg.sender], _token);\n', '            MemberToToken[msg.sender] = _token;\n', '            AnnoTrade memory _anno = AnnoTrade({\n', '               seller: msg.sender,\n', '               ifMedal:_ifMedal,\n', '               medal: _medal,\n', '               token: _token\n', '            });\n', '            uint newTokenTradeId = annoTrades.push(_anno) - 1;\n', '            AnnoTradeCreated(newTokenTradeId, _ifMedal, _medal, _token);\n', '            \n', '            return newTokenTradeId;\n', '        }\n', '    }\n', '    \n', '    function cancelTrade(uint _tradeId) public whenNotPaused {\n', '        AnnoTrade memory anno = annoTrades[_tradeId];\n', '        require(anno.seller == msg.sender);\n', '        if(anno.ifMedal){\n', '            medalBalances[msg.sender] = safeAdd(medalBalances[msg.sender], anno.medal);\n', '            MemberToMedal[msg.sender] = 0;\n', '        } else {\n', '            balances[msg.sender] = safeAdd(balances[msg.sender], anno.token);\n', '            MemberToToken[msg.sender] = 0;\n', '        }\n', '        delete annoTrades[_tradeId];\n', '        TradeCancel(_tradeId);\n', '    }\n', '    \n', '    function trade(uint _tradeId) public whenNotPaused {\n', '        AnnoTrade memory anno = annoTrades[_tradeId];\n', '        if(anno.ifMedal){\n', '            medalBalances[msg.sender] = safeAdd(medalBalances[msg.sender], anno.medal);\n', '            MemberToMedal[anno.seller] = 0;\n', '            transfer(anno.seller, anno.token);\n', '            delete annoTrades[_tradeId];\n', '            TradeComplete(_tradeId, msg.sender, anno.seller, anno.medal, anno.token);\n', '        } else {\n', '            balances[msg.sender] = safeAdd(balances[msg.sender], anno.token);\n', '            MemberToToken[anno.seller] = 0;\n', '            medalTransfer(anno.seller, anno.medal);\n', '            delete annoTrades[_tradeId];\n', '            TradeComplete(_tradeId, msg.sender, anno.seller, anno.medal, anno.token);\n', '        }\n', '    }\n', '    \n', '    function mine() public whenNotPaused {\n', '        uint level = MemberToLevel[msg.sender];\n', '        require(MemberToTime[msg.sender] < uint(now)); \n', '        require(level > 0);\n', '        _mint(salary[level], msg.sender);\n', '        MemberToTime[msg.sender] = safeAdd(MemberToTime[msg.sender], period);\n', '        Mine(msg.sender, salary[level]);\n', '    }\n', '    \n', '    function setBoardMember(uint one, uint two, uint three, uint four) public onlyAdmin {\n', '        boardMember[1] = one;\n', '        boardMember[2] = two;\n', '        boardMember[3] = three;\n', '        boardMember[4] = four;\n', '    }\n', '    \n', '    function setSalary(uint one, uint two, uint three, uint four) public onlyAdmin {\n', '        salary[1] = one;\n', '        salary[2] = two;\n', '        salary[3] = three;\n', '        salary[4] = four;\n', '    }\n', '    \n', '    function setPeriod(uint time) public onlyAdmin {\n', '        period = time;\n', '    }\n', '    \n', '    function getTrade(uint _tradeId) public view returns (\n', '        address seller,\n', '        bool ifMedal,\n', '        uint medal,\n', '        uint token \n', '    ) {\n', '        AnnoTrade memory _anno = annoTrades[_tradeId];\n', '        seller = _anno.seller;\n', '        ifMedal = _anno.ifMedal;\n', '        medal = _anno.medal;\n', '        token = _anno.token;\n', '    }\n', '    \n', '    function WhoIsTheContractMaster() public pure returns (string) {\n', '        return "Alexander The Exlosion";\n', '    }\n', '}']