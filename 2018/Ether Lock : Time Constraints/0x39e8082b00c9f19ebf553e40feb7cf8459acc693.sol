['pragma solidity ^0.4.13;\n', '\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    function DSAuth() public {\n', '        owner = msg.sender;\n', '        emit LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DSNote {\n', '    event LogNote(\n', '        bytes4   indexed  sig,\n', '        address  indexed  guy,\n', '        bytes32  indexed  foo,\n', '        bytes32  indexed  bar,\n', '        uint              wad,\n', '        bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '\n', '        assembly {\n', '            foo := calldataload(4)\n', '            bar := calldataload(36)\n', '        }\n', '\n', '        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);\n', '\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract DSStop is DSNote, DSAuth {\n', '\n', '    bool public stopped;\n', '\n', '    modifier stoppable {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    function stop() public auth note {\n', '        stopped = true;\n', '    }\n', '    function start() public auth note {\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Events {\n', '    event Approval(address indexed src, address indexed guy, uint wad);\n', '    event Transfer(address indexed src, address indexed dst, uint wad);\n', '}\n', '\n', 'contract ERC20 is ERC20Events {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address guy) public view returns (uint);\n', '    function allowance(address src, address guy) public view returns (uint);\n', '\n', '    function approve(address guy, uint wad) public returns (bool);\n', '    function transfer(address dst, uint wad) public returns (bool);\n', '    function transferFrom(\n', '        address src, address dst, uint wad\n', '    ) public returns (bool);\n', '}\n', '\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', '    // It&#39;s O(log n), instead of O(n) for naive repeated multiplication.\n', '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DSTokenBase is ERC20, DSMath {\n', '    uint256                                            _supply;\n', '    mapping (address => uint256)                       _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '\n', '    function DSTokenBase(uint supply) public {\n', '        _balances[msg.sender] = supply;\n', '        _supply = supply;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _supply;\n', '    }\n', '    function balanceOf(address src) public view returns (uint) {\n', '        return _balances[src];\n', '    }\n', '    function allowance(address src, address guy) public view returns (uint) {\n', '        return _approvals[src][guy];\n', '    }\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address guy, uint wad) public returns (bool) {\n', '        _approvals[msg.sender][guy] = wad;\n', '\n', '        emit Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract DSToken is DSTokenBase(0), DSStop {\n', '\n', '    string  public  symbol = "";\n', '    string   public  name = "";\n', '    uint256  public  decimals = 18; // standard token precision. override to customize\n', '\n', '    function DSToken(\n', '        string symbol_,\n', '        string name_\n', '    ) public {\n', '        symbol = symbol_;\n', '        name = name_;\n', '    }\n', '\n', '    event Mint(address indexed guy, uint wad);\n', '    event Burn(address indexed guy, uint wad);\n', '\n', '    function setName(string name_) public auth {\n', '        name = name_;\n', '    }\n', '\n', '    function approve(address guy) public stoppable returns (bool) {\n', '        return super.approve(guy, uint(-1));\n', '    }\n', '\n', '    function approve(address guy, uint wad) public stoppable returns (bool) {\n', '        return super.approve(guy, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        stoppable\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function push(address dst, uint wad) public {\n', '        transferFrom(msg.sender, dst, wad);\n', '    }\n', '    function pull(address src, uint wad) public {\n', '        transferFrom(src, msg.sender, wad);\n', '    }\n', '    function move(address src, address dst, uint wad) public {\n', '        transferFrom(src, dst, wad);\n', '    }\n', '\n', '    function mint(uint wad) public {\n', '        mint(msg.sender, wad);\n', '    }\n', '    function burn(uint wad) public {\n', '        burn(msg.sender, wad);\n', '    }\n', '    function mint(address guy, uint wad) public auth stoppable {\n', '        _balances[guy] = add(_balances[guy], wad);\n', '        _supply = add(_supply, wad);\n', '        emit Mint(guy, wad);\n', '    }\n', '    function burn(address guy, uint wad) public auth stoppable {\n', '        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {\n', '            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);\n', '        }\n', '\n', '        _balances[guy] = sub(_balances[guy], wad);\n', '        _supply = sub(_supply, wad);\n', '        emit Burn(guy, wad);\n', '    }\n', '}\n', '\n', '\n', '//==============================\n', '// 使用说明\n', '//1.发布DSToken合约\n', '//\n', '//2.发布TICDist代币操作合约\n', '//\n', '//3.钱包里面，DSToken绑定操作合约合约\n', '//\n', '//4.设置参数\n', '//\n', '// setDistConfig 创始人参数说明\n', '//["0xc94cd681477e6a70a4797a9Cbaa9F1E52366823c","0xCc1696E57E2Cd0dCd61164eE884B4994EA3B916A","0x9bD5DB3059186FA8eeAD8e4275a2DA50F0380528"] //有3个创始人\n', '//[51,15,34] //各自分配比例51%，15%，34%\n', '// setLockedConfig 锁仓参数说明\n', '//["0xc94cd681477e6a70a4797a9Cbaa9F1E52366823c"] //只有第一个创始人锁仓\n', '//[50]\t// 第一个人自己的份额，锁仓50%\n', '//[10]\t// 锁仓截至时间为，开始发行后的10天\n', '//\n', '//5.开始发行 startDist\n', '//==============================\n', '\n', '//===============================\n', '// TIC代币 操作合约\n', '//===============================\n', 'contract TICDist is DSAuth, DSMath {\n', '\n', '    DSToken  public  TIC;                   // TIC代币对象\n', '    uint256  public  initSupply = 0;        // 初始化发行供应量\n', '    uint256  public  decimals = 18;         // 代币精度，默认小数点后18位，不建议修改\n', '\n', '    // 发行相关\n', '    uint public distDay = 0;                // 发行 开始时间\n', '    bool public isDistConfig = false;       // 是否配置过发行标志\n', '    bool public isLockedConfig = false;     // 是否配置过锁仓标志\n', '    \n', '    bool public bTest = true;               // 锁仓的情况下，每天释放1%，做演示用\n', '    uint public testUnlockedDay = 0;        // 测试解锁的时间\n', '    \n', '    struct Detail {  \n', '        uint distPercent;   // 发行时，创始人的分配比例\n', '        uint lockedPercent; // 发行时，创始人的锁仓比例\n', '        uint lockedDay;     // 发行时，创始人的锁仓时间\n', '        uint256 lockedToken;   // 发行时，创始人的被锁仓代币\n', '    }\n', '\n', '    address[] public founderList;                 // 创始人列表\n', '    mapping (address => Detail)  public  founders;// 发行时，创始人的分配比例\n', '    \n', '    // 默认构造\n', '    function TICDist(uint256 initial_supply) public {\n', '        initSupply = initial_supply;\n', '    }\n', '\n', '    // 此操作合约，绑定代币接口, 注意，一开始代币创建，代币都在发行者账号里面\n', '    // @param  {DSToken} tic 代币对象\n', '    function setTIC(DSToken  tic) public auth {\n', '        // 判断之前没有绑定过\n', '        assert(address(TIC) == address(0));\n', '        // 本操作合约有代币所有权\n', '        assert(tic.owner() == address(this));\n', '        // 总发行量不能为0\n', '        assert(tic.totalSupply() == 0);\n', '        // 赋值\n', '        TIC = tic;\n', '        // 初始化代币总量，并把代币总量存到合约账号里面\n', '        initSupply = initSupply*10**uint256(decimals);\n', '        TIC.mint(initSupply);\n', '    }\n', '\n', '    // 设置发行参数\n', '    // @param  {address[]nt} founders_ 创始人列表\n', '    // @param  {uint[]} percents_ 创始人分配比例，总和必须小于100\n', '    function setDistConfig(address[] founders_, uint[] percents_) public auth {\n', '        // 判断是否配置过\n', '        assert(isDistConfig == false);\n', '        // 输入参数测试\n', '        assert(founders_.length > 0);\n', '        assert(founders_.length == percents_.length);\n', '        uint all_percents = 0;\n', '        uint i = 0;\n', '        for (i=0; i<percents_.length; ++i){\n', '            assert(percents_[i] > 0);\n', '            assert(founders_[i] != address(0));\n', '            all_percents += percents_[i];\n', '        }\n', '        assert(all_percents <= 100);\n', '        // 赋值\n', '        founderList = founders_;\n', '        for (i=0; i<founders_.length; ++i){\n', '            founders[founders_[i]].distPercent = percents_[i];\n', '        }\n', '        // 设置标志\n', '        isDistConfig = true;\n', '    }\n', '\n', '    // 设置发行锁仓参数\n', '    // @param  {address[]} founders_ 创始人列表，注意，不一定要所有创始人，只有锁仓需求的才要\n', '    // @param  {uint[]} percents_ 对应的锁仓比例\n', '    // @param  {uint[]} days_ 对应的锁仓时间，这个时间是相对distDay，发行后的时间\n', '    function setLockedConfig(address[] founders_, uint[] percents_, uint[] days_) public auth {\n', '        // 必须先设置发行参数\n', '        assert(isDistConfig == true);\n', '        // 判断是否配置过\n', '        assert(isLockedConfig == false);\n', '        // 判断是否有值\n', '        if (founders_.length > 0){\n', '            // 输入参数测试\n', '            assert(founders_.length == percents_.length);\n', '            assert(founders_.length == days_.length);\n', '            uint i = 0;\n', '            for (i=0; i<percents_.length; ++i){\n', '                assert(percents_[i] > 0);\n', '                assert(percents_[i] <= 100);\n', '                assert(days_[i] > 0);\n', '                assert(founders_[i] != address(0));\n', '            }\n', '            // 赋值\n', '            for (i=0; i<founders_.length; ++i){\n', '                founders[founders_[i]].lockedPercent = percents_[i];\n', '                founders[founders_[i]].lockedDay = days_[i];\n', '            }\n', '        }\n', '        // 设置标志\n', '        isLockedConfig = true;\n', '    }\n', '\n', '    // 开始发行\n', '    function startDist() public auth {\n', '        // 必须还没发行过\n', '        assert(distDay == 0);\n', '        // 判断必须配置过\n', '        assert(isDistConfig == true);\n', '        assert(isLockedConfig == true);\n', '        // 对每个创始人代币初始化\n', '        uint i = 0;\n', '        for(i=0; i<founderList.length; ++i){\n', '            // 获得创始人的份额\n', '            uint256 all_token_num = TIC.totalSupply()*founders[founderList[i]].distPercent/100;\n', '            assert(all_token_num > 0);\n', '            // 获得锁仓的份额\n', '            uint256 locked_token_num = all_token_num*founders[founderList[i]].lockedPercent/100;\n', '            // 记录锁仓的token\n', '            founders[founderList[i]].lockedToken = locked_token_num;\n', '            // 发放token给创始人\n', '            TIC.push(founderList[i], all_token_num - locked_token_num);\n', '        }\n', '        // 设置发行时间\n', '        distDay = today();\n', '        // 更新锁仓时间\n', '        for(i=0; i<founderList.length; ++i){\n', '            if (founders[founderList[i]].lockedDay != 0){\n', '                founders[founderList[i]].lockedDay += distDay;\n', '            }\n', '        }\n', '    }\n', '\n', '    // 确认锁仓时间是否到了，结束锁仓\n', '    function checkLockedToken() public {\n', '        // 必须发行过\n', '        assert(distDay != 0);\n', '        // 是否是测试\n', '        if (bTest){\n', '            // 判断今天解锁过了没有\n', '            assert(today() > testUnlockedDay);\n', '            // 每次固定解锁1%\n', '            uint unlock_percent = 1;\n', '            // 给锁仓的每个人，做解锁动作 TODO\n', '            uint i = 0;\n', '            for(i=0; i<founderList.length; ++i){\n', '                // 有锁仓需求的创始人 并且 有锁仓代币\n', '                if (founders[founderList[i]].lockedDay > 0 && founders[founderList[i]].lockedToken > 0){\n', '                    // 获得总的代币\n', '                    uint256 all_token_num = TIC.totalSupply()*founders[founderList[i]].distPercent/100;\n', '                    // 获得锁仓的份额\n', '                    uint256 locked_token_num = all_token_num*founders[founderList[i]].lockedPercent/100;\n', '                    // 每天释放的量\n', '                    uint256 unlock_token_num = locked_token_num*unlock_percent/founders[founderList[i]].lockedPercent;\n', '                    if (unlock_token_num > founders[founderList[i]].lockedToken){\n', '                        unlock_token_num = founders[founderList[i]].lockedToken;\n', '                    }\n', '                    // 开始解锁 token\n', '                    TIC.push(founderList[i], unlock_token_num);\n', '                    // 锁仓token数据减少\n', '                    founders[founderList[i]].lockedToken -= unlock_token_num;\n', '                }\n', '            }\n', '            // 刷新解锁时间\n', '            testUnlockedDay = today();            \n', '        } else {\n', '            // 有锁仓需求的创始人\n', '            assert(founders[msg.sender].lockedDay > 0);\n', '            // 有锁仓代币\n', '            assert(founders[msg.sender].lockedToken > 0);\n', '            // 判断是否解锁时间到\n', '            assert(today() > founders[msg.sender].lockedDay);\n', '            // 开始解锁 token\n', '            TIC.push(msg.sender, founders[msg.sender].lockedToken);\n', '            // 锁仓token数据清空\n', '            founders[msg.sender].lockedToken = 0;\n', '        }\n', '    }\n', '\n', '    // 获得当前时间 单位天\n', '    function today() public constant returns (uint) {\n', '        return time() / 24 hours;\n', '        // TODO test\n', '        //return time() / 1 minutes;\n', '    }\n', '   \n', '    // 获得区块链时间戳，单位秒\n', '    function time() public constant returns (uint) {\n', '        return block.timestamp;\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    function DSAuth() public {\n', '        owner = msg.sender;\n', '        emit LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DSNote {\n', '    event LogNote(\n', '        bytes4   indexed  sig,\n', '        address  indexed  guy,\n', '        bytes32  indexed  foo,\n', '        bytes32  indexed  bar,\n', '        uint              wad,\n', '        bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '\n', '        assembly {\n', '            foo := calldataload(4)\n', '            bar := calldataload(36)\n', '        }\n', '\n', '        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);\n', '\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract DSStop is DSNote, DSAuth {\n', '\n', '    bool public stopped;\n', '\n', '    modifier stoppable {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    function stop() public auth note {\n', '        stopped = true;\n', '    }\n', '    function start() public auth note {\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract ERC20Events {\n', '    event Approval(address indexed src, address indexed guy, uint wad);\n', '    event Transfer(address indexed src, address indexed dst, uint wad);\n', '}\n', '\n', 'contract ERC20 is ERC20Events {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address guy) public view returns (uint);\n', '    function allowance(address src, address guy) public view returns (uint);\n', '\n', '    function approve(address guy, uint wad) public returns (bool);\n', '    function transfer(address dst, uint wad) public returns (bool);\n', '    function transferFrom(\n', '        address src, address dst, uint wad\n', '    ) public returns (bool);\n', '}\n', '\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DSTokenBase is ERC20, DSMath {\n', '    uint256                                            _supply;\n', '    mapping (address => uint256)                       _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '\n', '    function DSTokenBase(uint supply) public {\n', '        _balances[msg.sender] = supply;\n', '        _supply = supply;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _supply;\n', '    }\n', '    function balanceOf(address src) public view returns (uint) {\n', '        return _balances[src];\n', '    }\n', '    function allowance(address src, address guy) public view returns (uint) {\n', '        return _approvals[src][guy];\n', '    }\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address guy, uint wad) public returns (bool) {\n', '        _approvals[msg.sender][guy] = wad;\n', '\n', '        emit Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', 'contract DSToken is DSTokenBase(0), DSStop {\n', '\n', '    string  public  symbol = "";\n', '    string   public  name = "";\n', '    uint256  public  decimals = 18; // standard token precision. override to customize\n', '\n', '    function DSToken(\n', '        string symbol_,\n', '        string name_\n', '    ) public {\n', '        symbol = symbol_;\n', '        name = name_;\n', '    }\n', '\n', '    event Mint(address indexed guy, uint wad);\n', '    event Burn(address indexed guy, uint wad);\n', '\n', '    function setName(string name_) public auth {\n', '        name = name_;\n', '    }\n', '\n', '    function approve(address guy) public stoppable returns (bool) {\n', '        return super.approve(guy, uint(-1));\n', '    }\n', '\n', '    function approve(address guy, uint wad) public stoppable returns (bool) {\n', '        return super.approve(guy, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        stoppable\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function push(address dst, uint wad) public {\n', '        transferFrom(msg.sender, dst, wad);\n', '    }\n', '    function pull(address src, uint wad) public {\n', '        transferFrom(src, msg.sender, wad);\n', '    }\n', '    function move(address src, address dst, uint wad) public {\n', '        transferFrom(src, dst, wad);\n', '    }\n', '\n', '    function mint(uint wad) public {\n', '        mint(msg.sender, wad);\n', '    }\n', '    function burn(uint wad) public {\n', '        burn(msg.sender, wad);\n', '    }\n', '    function mint(address guy, uint wad) public auth stoppable {\n', '        _balances[guy] = add(_balances[guy], wad);\n', '        _supply = add(_supply, wad);\n', '        emit Mint(guy, wad);\n', '    }\n', '    function burn(address guy, uint wad) public auth stoppable {\n', '        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {\n', '            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);\n', '        }\n', '\n', '        _balances[guy] = sub(_balances[guy], wad);\n', '        _supply = sub(_supply, wad);\n', '        emit Burn(guy, wad);\n', '    }\n', '}\n', '\n', '\n', '//==============================\n', '// 使用说明\n', '//1.发布DSToken合约\n', '//\n', '//2.发布TICDist代币操作合约\n', '//\n', '//3.钱包里面，DSToken绑定操作合约合约\n', '//\n', '//4.设置参数\n', '//\n', '// setDistConfig 创始人参数说明\n', '//["0xc94cd681477e6a70a4797a9Cbaa9F1E52366823c","0xCc1696E57E2Cd0dCd61164eE884B4994EA3B916A","0x9bD5DB3059186FA8eeAD8e4275a2DA50F0380528"] //有3个创始人\n', '//[51,15,34] //各自分配比例51%，15%，34%\n', '// setLockedConfig 锁仓参数说明\n', '//["0xc94cd681477e6a70a4797a9Cbaa9F1E52366823c"] //只有第一个创始人锁仓\n', '//[50]\t// 第一个人自己的份额，锁仓50%\n', '//[10]\t// 锁仓截至时间为，开始发行后的10天\n', '//\n', '//5.开始发行 startDist\n', '//==============================\n', '\n', '//===============================\n', '// TIC代币 操作合约\n', '//===============================\n', 'contract TICDist is DSAuth, DSMath {\n', '\n', '    DSToken  public  TIC;                   // TIC代币对象\n', '    uint256  public  initSupply = 0;        // 初始化发行供应量\n', '    uint256  public  decimals = 18;         // 代币精度，默认小数点后18位，不建议修改\n', '\n', '    // 发行相关\n', '    uint public distDay = 0;                // 发行 开始时间\n', '    bool public isDistConfig = false;       // 是否配置过发行标志\n', '    bool public isLockedConfig = false;     // 是否配置过锁仓标志\n', '    \n', '    bool public bTest = true;               // 锁仓的情况下，每天释放1%，做演示用\n', '    uint public testUnlockedDay = 0;        // 测试解锁的时间\n', '    \n', '    struct Detail {  \n', '        uint distPercent;   // 发行时，创始人的分配比例\n', '        uint lockedPercent; // 发行时，创始人的锁仓比例\n', '        uint lockedDay;     // 发行时，创始人的锁仓时间\n', '        uint256 lockedToken;   // 发行时，创始人的被锁仓代币\n', '    }\n', '\n', '    address[] public founderList;                 // 创始人列表\n', '    mapping (address => Detail)  public  founders;// 发行时，创始人的分配比例\n', '    \n', '    // 默认构造\n', '    function TICDist(uint256 initial_supply) public {\n', '        initSupply = initial_supply;\n', '    }\n', '\n', '    // 此操作合约，绑定代币接口, 注意，一开始代币创建，代币都在发行者账号里面\n', '    // @param  {DSToken} tic 代币对象\n', '    function setTIC(DSToken  tic) public auth {\n', '        // 判断之前没有绑定过\n', '        assert(address(TIC) == address(0));\n', '        // 本操作合约有代币所有权\n', '        assert(tic.owner() == address(this));\n', '        // 总发行量不能为0\n', '        assert(tic.totalSupply() == 0);\n', '        // 赋值\n', '        TIC = tic;\n', '        // 初始化代币总量，并把代币总量存到合约账号里面\n', '        initSupply = initSupply*10**uint256(decimals);\n', '        TIC.mint(initSupply);\n', '    }\n', '\n', '    // 设置发行参数\n', '    // @param  {address[]nt} founders_ 创始人列表\n', '    // @param  {uint[]} percents_ 创始人分配比例，总和必须小于100\n', '    function setDistConfig(address[] founders_, uint[] percents_) public auth {\n', '        // 判断是否配置过\n', '        assert(isDistConfig == false);\n', '        // 输入参数测试\n', '        assert(founders_.length > 0);\n', '        assert(founders_.length == percents_.length);\n', '        uint all_percents = 0;\n', '        uint i = 0;\n', '        for (i=0; i<percents_.length; ++i){\n', '            assert(percents_[i] > 0);\n', '            assert(founders_[i] != address(0));\n', '            all_percents += percents_[i];\n', '        }\n', '        assert(all_percents <= 100);\n', '        // 赋值\n', '        founderList = founders_;\n', '        for (i=0; i<founders_.length; ++i){\n', '            founders[founders_[i]].distPercent = percents_[i];\n', '        }\n', '        // 设置标志\n', '        isDistConfig = true;\n', '    }\n', '\n', '    // 设置发行锁仓参数\n', '    // @param  {address[]} founders_ 创始人列表，注意，不一定要所有创始人，只有锁仓需求的才要\n', '    // @param  {uint[]} percents_ 对应的锁仓比例\n', '    // @param  {uint[]} days_ 对应的锁仓时间，这个时间是相对distDay，发行后的时间\n', '    function setLockedConfig(address[] founders_, uint[] percents_, uint[] days_) public auth {\n', '        // 必须先设置发行参数\n', '        assert(isDistConfig == true);\n', '        // 判断是否配置过\n', '        assert(isLockedConfig == false);\n', '        // 判断是否有值\n', '        if (founders_.length > 0){\n', '            // 输入参数测试\n', '            assert(founders_.length == percents_.length);\n', '            assert(founders_.length == days_.length);\n', '            uint i = 0;\n', '            for (i=0; i<percents_.length; ++i){\n', '                assert(percents_[i] > 0);\n', '                assert(percents_[i] <= 100);\n', '                assert(days_[i] > 0);\n', '                assert(founders_[i] != address(0));\n', '            }\n', '            // 赋值\n', '            for (i=0; i<founders_.length; ++i){\n', '                founders[founders_[i]].lockedPercent = percents_[i];\n', '                founders[founders_[i]].lockedDay = days_[i];\n', '            }\n', '        }\n', '        // 设置标志\n', '        isLockedConfig = true;\n', '    }\n', '\n', '    // 开始发行\n', '    function startDist() public auth {\n', '        // 必须还没发行过\n', '        assert(distDay == 0);\n', '        // 判断必须配置过\n', '        assert(isDistConfig == true);\n', '        assert(isLockedConfig == true);\n', '        // 对每个创始人代币初始化\n', '        uint i = 0;\n', '        for(i=0; i<founderList.length; ++i){\n', '            // 获得创始人的份额\n', '            uint256 all_token_num = TIC.totalSupply()*founders[founderList[i]].distPercent/100;\n', '            assert(all_token_num > 0);\n', '            // 获得锁仓的份额\n', '            uint256 locked_token_num = all_token_num*founders[founderList[i]].lockedPercent/100;\n', '            // 记录锁仓的token\n', '            founders[founderList[i]].lockedToken = locked_token_num;\n', '            // 发放token给创始人\n', '            TIC.push(founderList[i], all_token_num - locked_token_num);\n', '        }\n', '        // 设置发行时间\n', '        distDay = today();\n', '        // 更新锁仓时间\n', '        for(i=0; i<founderList.length; ++i){\n', '            if (founders[founderList[i]].lockedDay != 0){\n', '                founders[founderList[i]].lockedDay += distDay;\n', '            }\n', '        }\n', '    }\n', '\n', '    // 确认锁仓时间是否到了，结束锁仓\n', '    function checkLockedToken() public {\n', '        // 必须发行过\n', '        assert(distDay != 0);\n', '        // 是否是测试\n', '        if (bTest){\n', '            // 判断今天解锁过了没有\n', '            assert(today() > testUnlockedDay);\n', '            // 每次固定解锁1%\n', '            uint unlock_percent = 1;\n', '            // 给锁仓的每个人，做解锁动作 TODO\n', '            uint i = 0;\n', '            for(i=0; i<founderList.length; ++i){\n', '                // 有锁仓需求的创始人 并且 有锁仓代币\n', '                if (founders[founderList[i]].lockedDay > 0 && founders[founderList[i]].lockedToken > 0){\n', '                    // 获得总的代币\n', '                    uint256 all_token_num = TIC.totalSupply()*founders[founderList[i]].distPercent/100;\n', '                    // 获得锁仓的份额\n', '                    uint256 locked_token_num = all_token_num*founders[founderList[i]].lockedPercent/100;\n', '                    // 每天释放的量\n', '                    uint256 unlock_token_num = locked_token_num*unlock_percent/founders[founderList[i]].lockedPercent;\n', '                    if (unlock_token_num > founders[founderList[i]].lockedToken){\n', '                        unlock_token_num = founders[founderList[i]].lockedToken;\n', '                    }\n', '                    // 开始解锁 token\n', '                    TIC.push(founderList[i], unlock_token_num);\n', '                    // 锁仓token数据减少\n', '                    founders[founderList[i]].lockedToken -= unlock_token_num;\n', '                }\n', '            }\n', '            // 刷新解锁时间\n', '            testUnlockedDay = today();            \n', '        } else {\n', '            // 有锁仓需求的创始人\n', '            assert(founders[msg.sender].lockedDay > 0);\n', '            // 有锁仓代币\n', '            assert(founders[msg.sender].lockedToken > 0);\n', '            // 判断是否解锁时间到\n', '            assert(today() > founders[msg.sender].lockedDay);\n', '            // 开始解锁 token\n', '            TIC.push(msg.sender, founders[msg.sender].lockedToken);\n', '            // 锁仓token数据清空\n', '            founders[msg.sender].lockedToken = 0;\n', '        }\n', '    }\n', '\n', '    // 获得当前时间 单位天\n', '    function today() public constant returns (uint) {\n', '        return time() / 24 hours;\n', '        // TODO test\n', '        //return time() / 1 minutes;\n', '    }\n', '   \n', '    // 获得区块链时间戳，单位秒\n', '    function time() public constant returns (uint) {\n', '        return block.timestamp;\n', '    }\n', '}']
