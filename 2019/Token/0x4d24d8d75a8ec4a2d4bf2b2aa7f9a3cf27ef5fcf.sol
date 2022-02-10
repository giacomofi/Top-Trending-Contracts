['pragma solidity ^0.4.25;\n', '\n', '/*\n', 'Name: MV Express Coin \n', 'Symbol: MEC\n', '*/\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = 0x88253D87990EdD1E647c3B6eD21F57fb061a3040;\n', '        emit LogSetOwner(0x88253D87990EdD1E647c3B6eD21F57fb061a3040);\n', '    }\n', '\n', '    function setOwner(address owner_0x88253D87990EdD1E647c3B6eD21F57fb061a3040)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_0x88253D87990EdD1E647c3B6eD21F57fb061a3040;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20Events {\n', '    event Approval(address indexed src, address indexed guy, uint wad);\n', '    event Transfer(address indexed src, address indexed dst, uint wad);\n', '}\n', '\n', 'contract ERC20 is ERC20Events {\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address guy) public view returns (uint);\n', '    function allowance(address src, address guy) public view returns (uint);\n', '\n', '    function approve(address guy, uint wad) public returns (bool);\n', '    function transfer(address dst, uint wad) public returns (bool);\n', '    function transferFrom(\n', '        address src, address dst, uint wad\n', '    ) public returns (bool);\n', '}\n', '\n', 'contract DSTokenBase is ERC20, DSMath {\n', '    uint256                                            _supply;\n', '    mapping (address => uint256)                       _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '\n', '    constructor(uint supply) public {\n', '        _balances[msg.sender] = supply;\n', '        _supply = supply;\n', '    }\n', '\n', ' /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '    function totalSupply() public view returns (uint) {\n', '        return _supply;\n', '    }\n', '\n', ' /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param src The address to query the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '\n', '    function balanceOf(address src) public view returns (uint) {\n', '        return _balances[src];\n', '    }\n', '\n', ' /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param src address The address which owns the funds.\n', '   * @param guy address The address which will spend the funds.\n', '   */\n', '    function allowance(address src, address guy) public view returns (uint) {\n', '        return _approvals[src][guy];\n', '    }\n', '\n', '  /**\n', '   * @dev Transfer token for a specified address\n', '   * @param dst The address to transfer to.\n', '   * @param wad The amount to be transferred.\n', '   */\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', ' /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param src address The address which you want to send tokens from\n', '   * @param dst address The address which you want to transfer to\n', '   * @param wad uint256 the amount of tokens to be transferred\n', '   */\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', ' /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param guy The address which will spend the funds.\n', '   * @param wad The amount of tokens to be spent.\n', '   */\n', '\n', '    function approve(address guy, uint wad) public returns (bool) {\n', '        _approvals[msg.sender][guy] = wad;\n', '\n', '        emit Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '\n', ' /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param src The address which will spend the funds.\n', '   * @param wad The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address src,\n', '    uint256 wad\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(src != address(0));\n', '\n', '    _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);\n', '    emit Approval(msg.sender, src, _approvals[msg.sender][src]);\n', '    return true;\n', '  }\n', '\n', ' /**\n', '   * @dev Decrese the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param src The address which will spend the funds.\n', '   * @param wad The amount of tokens to increase the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address src,\n', '    uint256 wad\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(src != address(0));\n', '    _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '    emit Approval(msg.sender, src, _approvals[msg.sender][src]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract DSNote {\n', '    event LogNote(\n', '        bytes4   indexed  sig,\n', '        address  indexed  guy,\n', '        bytes32  indexed  foo,\n', '        bytes32  indexed  bar,\n', '        uint              wad,\n', '        bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '\n', '        assembly {\n', '            foo := calldataload(4)\n', '            bar := calldataload(36)\n', '        }\n', '\n', '        emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);\n', '\n', '        _;\n', '    }\n', '}\n', '\n', 'contract DSStop is DSNote, DSAuth {\n', '\n', '    bool public stopped;\n', '\n', '    modifier stoppable {\n', '        require(!stopped);\n', '        _;\n', '    }\n', '    function stop() public auth note {\n', '        stopped = true;\n', '    }\n', '    function start() public auth note {\n', '        stopped = false;\n', '    }\n', '\n', '}\n', '\n', '\n', 'contract MVExpressCoin is DSTokenBase , DSStop {\n', '\n', '    string  public  symbol="MEC";\n', '    string  public  name="MV Express Coin";\n', '    uint256  public  decimals = 18; // Standard Token Precision\n', '    uint256 public initialSupply=100000000999999990000000000;\n', '    address public burnAdmin;\n', '    constructor() public\n', '    DSTokenBase(initialSupply)\n', '    {\n', '        burnAdmin=0x88253D87990EdD1E647c3B6eD21F57fb061a3040;\n', '    }\n', '\n', '    event Burn(address indexed guy, uint wad);\n', '\n', ' /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyAdmin() {\n', '    require(isAdmin());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isAdmin() public view returns(bool) {\n', '    return msg.sender == burnAdmin;\n', '}\n', '\n', '/**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyAdmin {\n', '    burnAdmin = address(0);\n', '  }\n', '\n', '    function approve(address guy) public stoppable returns (bool) {\n', '        return super.approve(guy, uint(-1));\n', '    }\n', '\n', '    function approve(address guy, uint wad) public stoppable returns (bool) {\n', '        return super.approve(guy, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad)\n', '        public\n', '        stoppable\n', '        returns (bool)\n', '    {\n', '        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    /**\n', '   * @dev Burns a specific amount of tokens from the target address\n', '   * @param guy address The address which you want to send tokens from\n', '   * @param wad uint256 The amount of token to be burned\n', '   */\n', '    function burnfromAdmin(address guy, uint wad) public onlyAdmin {\n', '        require(guy != address(0));\n', '\n', '\n', '        _balances[guy] = sub(_balances[guy], wad);\n', '        _supply = sub(_supply, wad);\n', '\n', '        emit Burn(guy, wad);\n', '        emit Transfer(guy, address(0), wad);\n', '    }\n', '\n', '\n', '}']