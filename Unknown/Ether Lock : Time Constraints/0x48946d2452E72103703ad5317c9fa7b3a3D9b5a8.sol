['// Copyright (C) 2017 DappHub, LLC\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '//import "ds-exec/exec.sol";\n', '\n', 'contract DSExec {\n', '    function tryExec( address target, bytes calldata, uint value)\n', '    internal\n', '    returns (bool call_ret)\n', '    {\n', '        return target.call.value(value)(calldata);\n', '    }\n', '    function exec( address target, bytes calldata, uint value)\n', '    internal\n', '    {\n', '        if(!tryExec(target, calldata, value)) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    // Convenience aliases\n', '    function exec( address t, bytes c )\n', '    internal\n', '    {\n', '        exec(t, c, 0);\n', '    }\n', '    function exec( address t, uint256 v )\n', '    internal\n', '    {\n', '        bytes memory c; exec(t, c, v);\n', '    }\n', '    function tryExec( address t, bytes c )\n', '    internal\n', '    returns (bool)\n', '    {\n', '        return tryExec(t, c, 0);\n', '    }\n', '    function tryExec( address t, uint256 v )\n', '    internal\n', '    returns (bool)\n', '    {\n', '        bytes memory c; return tryExec(t, c, v);\n', '    }\n', '}\n', '\n', '//import "ds-auth/auth.sol";\n', 'contract DSAuthority {\n', '    function canCall(\n', '    address src, address dst, bytes4 sig\n', '    ) constant returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    function DSAuth() {\n', '        owner = msg.sender;\n', '        LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '    auth\n', '    {\n', '        owner = owner_;\n', '        LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '    auth\n', '    {\n', '        authority = authority_;\n', '        LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        assert(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '\n', '    function assert(bool x) internal {\n', '        if (!x) throw;\n', '    }\n', '}\n', '\n', '//import "ds-note/note.sol";\n', 'contract DSNote {\n', '    event LogNote(\n', '    bytes4   indexed  sig,\n', '    address  indexed  guy,\n', '    bytes32  indexed  foo,\n', '    bytes32  indexed  bar,\n', '    uint        wad,\n', '    bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '\n', '        assembly {\n', '        foo := calldataload(4)\n', '        bar := calldataload(36)\n', '        }\n', '\n', '        LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);\n', '\n', '        _;\n', '    }\n', '}\n', '\n', '\n', '//import "ds-math/math.sol";\n', 'contract DSMath {\n', '\n', '    /*\n', '    standard uint256 functions\n', '     */\n', '\n', '    function add(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert((z = x + y) >= x);\n', '    }\n', '\n', '    function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        assert((z = x - y) <= x);\n', '    }\n', '\n', '    function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        z = x * y;\n', '        assert(x == 0 || z / x == y);\n', '    }\n', '\n', '    function div(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        z = x / y;\n', '    }\n', '\n', '    function min(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint256 x, uint256 y) constant internal returns (uint256 z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    /*\n', '    uint128 functions (h is for half)\n', '     */\n', '\n', '\n', '    function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        assert((z = x + y) >= x);\n', '    }\n', '\n', '    function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        assert((z = x - y) <= x);\n', '    }\n', '\n', '    function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        z = x * y;\n', '        assert(x == 0 || z / x == y);\n', '    }\n', '\n', '    function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        z = x / y;\n', '    }\n', '\n', '    function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '\n', '    /*\n', '    int256 functions\n', '     */\n', '\n', '    function imin(int256 x, int256 y) constant internal returns (int256 z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int256 x, int256 y) constant internal returns (int256 z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    /*\n', '    WAD math\n', '     */\n', '\n', '    uint128 constant WAD = 10 ** 18;\n', '\n', '    function wadd(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hadd(x, y);\n', '    }\n', '\n', '    function wsub(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hsub(x, y);\n', '    }\n', '\n', '    function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        z = cast((uint256(x) * y + WAD / 2) / WAD);\n', '    }\n', '\n', '    function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        z = cast((uint256(x) * WAD + y / 2) / y);\n', '    }\n', '\n', '    function wmin(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hmin(x, y);\n', '    }\n', '    function wmax(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hmax(x, y);\n', '    }\n', '\n', '    /*\n', '    RAY math\n', '     */\n', '\n', '    uint128 constant RAY = 10 ** 27;\n', '\n', '    function radd(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hadd(x, y);\n', '    }\n', '\n', '    function rsub(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hsub(x, y);\n', '    }\n', '\n', '    function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        z = cast((uint256(x) * y + RAY / 2) / RAY);\n', '    }\n', '\n', '    function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {\n', '        z = cast((uint256(x) * RAY + y / 2) / y);\n', '    }\n', '\n', '    function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {\n', '        // This famous algorithm is called "exponentiation by squaring"\n', '        // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '        //\n', '        // It&#39;s O(log n), instead of O(n) for naive repeated multiplication.\n', '        //\n', '        // These facts are why it works:\n', '        //\n', '        //  If n is even, then x^n = (x^2)^(n/2).\n', '        //  If n is odd,  then x^n = x * x^(n-1),\n', '        //   and applying the equation for even x gives\n', '        //    x^n = x * (x^2)^((n-1) / 2).\n', '        //\n', '        //  Also, EVM division is flooring and\n', '        //    floor[(n-1) / 2] = floor[n / 2].\n', '\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '\n', '    function rmin(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hmin(x, y);\n', '    }\n', '    function rmax(uint128 x, uint128 y) constant internal returns (uint128) {\n', '        return hmax(x, y);\n', '    }\n', '\n', '    function cast(uint256 x) constant internal returns (uint128 z) {\n', '        assert((z = uint128(x)) == x);\n', '    }\n', '\n', '}\n', '\n', '//import "erc20/erc20.sol";\n', 'contract ERC20 {\n', '    function totalSupply() constant returns (uint supply);\n', '    function balanceOf( address who ) constant returns (uint value);\n', '    function allowance( address owner, address spender ) constant returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) returns (bool ok);\n', '    function transferFrom( address from, address to, uint value) returns (bool ok);\n', '    function approve( address spender, uint value ) returns (bool ok);\n', '\n', '    event Transfer( address indexed from, address indexed to, uint value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '//import "ds-token/base.sol";\n', 'contract DSTokenBase is ERC20, DSMath {\n', '    uint256                                            _supply;\n', '    mapping (address => uint256)                       _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '\n', '    function DSTokenBase(uint256 supply) {\n', '        _balances[msg.sender] = supply;\n', '        _supply = supply;\n', '    }\n', '\n', '    function totalSupply() constant returns (uint256) {\n', '        return _supply;\n', '    }\n', '    function balanceOf(address src) constant returns (uint256) {\n', '        return _balances[src];\n', '    }\n', '    function allowance(address src, address guy) constant returns (uint256) {\n', '        return _approvals[src][guy];\n', '    }\n', '\n', '    function transfer(address dst, uint wad) returns (bool) {\n', '        assert(_balances[msg.sender] >= wad);\n', '\n', '        _balances[msg.sender] = sub(_balances[msg.sender], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        Transfer(msg.sender, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad) returns (bool) {\n', '        assert(_balances[src] >= wad);\n', '        assert(_approvals[src][msg.sender] >= wad);\n', '\n', '        _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address guy, uint256 wad) returns (bool) {\n', '        _approvals[msg.sender][guy] = wad;\n', '\n', '        Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '\n', '//import "ds-stop/stop.sol";\n', 'contract DSStop is DSAuth, DSNote {\n', '\n', '    bool public stopped;\n', '\n', '    modifier stoppable {\n', '        assert (!stopped);\n', '        _;\n', '    }\n', '    function stop() auth note {\n', '        stopped = true;\n', '    }\n', '    function start() auth note {\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '\n', '//import "ds-token/token.sol";\n', 'contract DSToken is DSTokenBase(0), DSStop {\n', '\n', '    bytes32  public  symbol;\n', '    uint256  public  decimals = 18; // standard token precision. override to customize\n', '    address  public  generator;\n', '\n', '    modifier onlyGenerator {\n', '        if(msg.sender!=generator) throw;\n', '        _;\n', '    }\n', '\n', '    function DSToken(bytes32 symbol_) {\n', '        symbol = symbol_;\n', '        generator=msg.sender;\n', '    }\n', '\n', '    function transfer(address dst, uint wad) stoppable note returns (bool) {\n', '        return super.transfer(dst, wad);\n', '    }\n', '    function transferFrom(\n', '    address src, address dst, uint wad\n', '    ) stoppable note returns (bool) {\n', '        return super.transferFrom(src, dst, wad);\n', '    }\n', '    function approve(address guy, uint wad) stoppable note returns (bool) {\n', '        return super.approve(guy, wad);\n', '    }\n', '\n', '    function push(address dst, uint128 wad) returns (bool) {\n', '        return transfer(dst, wad);\n', '    }\n', '    function pull(address src, uint128 wad) returns (bool) {\n', '        return transferFrom(src, msg.sender, wad);\n', '    }\n', '\n', '    function mint(uint128 wad) auth stoppable note {\n', '        _balances[msg.sender] = add(_balances[msg.sender], wad);\n', '        _supply = add(_supply, wad);\n', '    }\n', '    function burn(uint128 wad) auth stoppable note {\n', '        _balances[msg.sender] = sub(_balances[msg.sender], wad);\n', '        _supply = sub(_supply, wad);\n', '    }\n', '\n', '    // owner can transfer token even stop,\n', '    function generatorTransfer(address dst, uint wad) onlyGenerator note returns (bool) {\n', '        return super.transfer(dst, wad);\n', '    }\n', '\n', '    // Optional token name\n', '\n', '    bytes32   public  name = "";\n', '\n', '    function setName(bytes32 name_) auth {\n', '        name = name_;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract kkkTokenSale is DSStop, DSMath, DSExec {\n', '\n', '    DSToken public kkk;\n', '\n', '    // kkk PRICES (ETH/kkk)\n', '    uint128 public constant PUBLIC_SALE_PRICE = 200000 ether;\n', '\n', '    uint128 public constant TOTAL_SUPPLY = 10 ** 11 * 1 ether;  // 100 billion kkk in total\n', '\n', '    uint128 public constant SELL_SOFT_LIMIT = TOTAL_SUPPLY * 12 / 100; // soft limit is 12% , 60000 eth\n', '    uint128 public constant SELL_HARD_LIMIT = TOTAL_SUPPLY * 16 / 100; // hard limit is 16% , 80000 eth\n', '\n', '    uint128 public constant FUTURE_DISTRIBUTE_LIMIT = TOTAL_SUPPLY * 84 / 100; // 84% for future distribution\n', '\n', '    uint128 public constant USER_BUY_LIMIT = 500 ether; // 500 ether limit\n', '    uint128 public constant MAX_GAS_PRICE = 50000000000;  // 50GWei\n', '\n', '    uint public startTime;\n', '    uint public endTime;\n', '\n', '    bool public moreThanSoftLimit;\n', '\n', '    mapping (address => uint)  public  userBuys; // limit to 500 eth\n', '\n', '    address public destFoundation; //multisig account , 4-of-6\n', '\n', '    uint128 public sold;\n', '    uint128 public constant soldByChannels = 40000 * 200000 ether; // 2 ICO websites, each 20000 eth\n', '\n', '    function kkkTokenSale(uint startTime_, address destFoundation_) {\n', '\n', '        kkk = new DSToken("kkk");\n', '\n', '        destFoundation = destFoundation_;\n', '\n', '        startTime = startTime_;\n', '        endTime = startTime + 14 days;\n', '\n', '        sold = soldByChannels; // sold by 3rd party ICO websites;\n', '        kkk.mint(TOTAL_SUPPLY);\n', '\n', '        kkk.transfer(destFoundation, FUTURE_DISTRIBUTE_LIMIT);\n', '        kkk.transfer(destFoundation, soldByChannels);\n', '\n', '        //disable transfer\n', '        kkk.stop();\n', '    }\n', '\n', '    // overrideable for easy testing\n', '    function time() constant returns (uint) {\n', '        return now;\n', '    }\n', '\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) return false;\n', '        assembly {\n', '        size := extcodesize(_addr)\n', '        }\n', '        return size > 0;\n', '    }\n', '\n', '    function canBuy(uint total) returns (bool) {\n', '        return total <= USER_BUY_LIMIT;\n', '    }\n', '\n', '    function() payable stoppable note {\n', '\n', '        require(!isContract(msg.sender));\n', '        require(msg.value >= 0.01 ether);\n', '        require(tx.gasprice <= MAX_GAS_PRICE);\n', '\n', '        assert(time() >= startTime && time() < endTime);\n', '\n', '        var toFund = cast(msg.value);\n', '\n', '        var requested = wmul(toFund, PUBLIC_SALE_PRICE);\n', '\n', '        // selling SELL_HARD_LIMIT tokens ends the sale\n', '        if( add(sold, requested) >= SELL_HARD_LIMIT) {\n', '            requested = SELL_HARD_LIMIT - sold;\n', '            toFund = wdiv(requested, PUBLIC_SALE_PRICE);\n', '\n', '            endTime = time();\n', '        }\n', '\n', '        // User cannot buy more than USER_BUY_LIMIT\n', '        var totalUserBuy = add(userBuys[msg.sender], toFund);\n', '        assert(canBuy(totalUserBuy));\n', '        userBuys[msg.sender] = totalUserBuy;\n', '\n', '        sold = hadd(sold, requested);\n', '\n', '        // Soft limit triggers the sale to close in 24 hours\n', '        if( !moreThanSoftLimit && sold >= SELL_SOFT_LIMIT ) {\n', '            moreThanSoftLimit = true;\n', '            endTime = time() + 24 hours; // last 24 hours after soft limit,\n', '        }\n', '\n', '        kkk.start();\n', '        kkk.transfer(msg.sender, requested);\n', '        kkk.stop();\n', '\n', '        exec(destFoundation, toFund); // send collected ETH to multisig\n', '\n', '        // return excess ETH to the user\n', '        uint toReturn = sub(msg.value, toFund);\n', '        if(toReturn > 0) {\n', '            exec(msg.sender, toReturn);\n', '        }\n', '    }\n', '\n', '    function setStartTime(uint startTime_) auth note {\n', '        require(time() <= startTime && time() <= startTime_);\n', '\n', '        startTime = startTime_;\n', '        endTime = startTime + 14 days;\n', '    }\n', '\n', '    function finalize() auth note {\n', '        require(time() >= endTime);\n', '\n', '        // enable transfer\n', '        kkk.start();\n', '\n', '        // transfer undistributed kkk\n', '        kkk.transfer(destFoundation, kkk.balanceOf(this));\n', '\n', '        // owner -> destFoundation\n', '        kkk.setOwner(destFoundation);\n', '    }\n', '\n', '\n', '    // @notice This method can be used by the controller to extract mistakenly\n', '    //  sent tokens to this contract.\n', '    // @param dst The address that will be receiving the tokens\n', '    // @param wad The amount of tokens to transfer\n', '    // @param _token The address of the token contract that you want to recover\n', '    function transferTokens(address dst, uint wad, address _token) public auth note {\n', '        ERC20 token = ERC20(_token);\n', '        token.transfer(dst, wad);\n', '    }\n', '\n', '    function summary()constant returns(\n', '        uint128 _sold,\n', '        uint _startTime,\n', '        uint _endTime)\n', '        {\n', '        _sold = sold;\n', '        _startTime = startTime;\n', '        _endTime = endTime;\n', '        return;\n', '    }\n', '\n', '}']