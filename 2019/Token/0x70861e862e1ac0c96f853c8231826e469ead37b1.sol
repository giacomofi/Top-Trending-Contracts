['pragma solidity >=0.5.0 <0.6.0;\n', '\n', '/// @dev The token controller contract must implement these functions\n', 'contract TokenController {\n', '    /// @notice Notifies the controller about a token transfer allowing the\n', '    ///  controller to react if desired\n', '    /// @param _from The origin of the transfer\n', '    /// @param _fromBalance Original token balance of _from address\n', '    /// @param _amount The amount of the transfer\n', '    /// @return The adjusted transfer amount filtered by a specific token controller.\n', '    function onTokenTransfer(address _from, uint _fromBalance, uint _amount) public returns(uint);\n', '}\n', '\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        emit LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(address(authority));\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, address(this), sig);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract DSNote {\n', '    event LogNote(\n', '        bytes4   indexed  sig,\n', '        address  indexed  guy,\n', '        bytes32  indexed  foo,\n', '        bytes32  indexed  bar,\n', '        uint256           wad,\n', '        bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '        uint256 wad;\n', '\n', '        assembly {\n', '            foo := calldataload(4)\n', '            bar := calldataload(36)\n', '            wad := callvalue\n', '        }\n', '\n', '        emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);\n', '\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf( address who ) public view returns (uint value);\n', '    function allowance( address owner, address spender ) public view returns (uint _allowance);\n', '\n', '    function transfer( address to, uint value) public returns (bool ok);\n', '    function transferFrom( address from, address to, uint value) public returns (bool ok);\n', '    function approve( address spender, uint value) public returns (bool ok);\n', '\n', '    event Transfer( address indexed from, address indexed to, uint value);\n', '    event Approval( address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x, "ds-math-add-overflow");\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x, "ds-math-sub-underflow");\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");\n', '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract DSStop is DSNote, DSAuth {\n', '    bool public stopped;\n', '\n', '    modifier stoppable {\n', '        require(!stopped, "ds-stop-is-stopped");\n', '        _;\n', '    }\n', '    function stop() public auth note {\n', '        stopped = true;\n', '    }\n', '    function start() public auth note {\n', '        stopped = false;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Managed {\n', '    /// @notice The address of the manager is the only address that can call\n', '    ///  a function with this modifier\n', '    modifier onlyManager { require(msg.sender == manager); _; }\n', '\n', '    address public manager;\n', '\n', '    constructor() public { manager = msg.sender;}\n', '\n', '    /// @notice Changes the manager of the contract\n', '    /// @param _newManager The new manager of the contract\n', '    function changeManager(address _newManager) public onlyManager {\n', '        manager = _newManager;\n', '    }\n', '    \n', '    /// @dev Internal function to determine if an address is a contract\n', '    /// @param _addr The address being queried\n', '    /// @return True if `_addr` is a contract\n', '    function isContract(address _addr) view internal returns(bool) {\n', '        uint size = 0;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size > 0;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract ControllerManager is DSAuth {\n', '    address[] public controllers;\n', '    \n', '    function addController(address _ctrl) public auth {\n', '        require(_ctrl != address(0));\n', '        controllers.push(_ctrl);\n', '    }\n', '    \n', '    function removeController(address _ctrl) public auth {\n', '        for (uint idx = 0; idx < controllers.length; idx++) {\n', '            if (controllers[idx] == _ctrl) {\n', '                controllers[idx] = controllers[controllers.length - 1];\n', '                controllers.length -= 1;\n', '                return;\n', '            }\n', '        }\n', '    }\n', '    \n', '    // Return the adjusted transfer amount after being filtered by all token controllers.\n', '    function onTransfer(address _from, uint _fromBalance, uint _amount) public returns(uint) {\n', '        uint adjustedAmount = _amount;\n', '        for (uint i = 0; i < controllers.length; i++) {\n', '            adjustedAmount = TokenController(controllers[i]).onTokenTransfer(_from, _fromBalance, adjustedAmount);\n', '            require(adjustedAmount <= _amount, "TokenController-isnot-allowed-to-lift-transfer-amount");\n', '            if (adjustedAmount == 0) return 0;\n', '        }\n', '        return adjustedAmount;\n', '    }\n', '}\n', '\n', '\n', 'contract DOSToken is ERC20, DSMath, DSStop, Managed {\n', "    string public constant name = 'DOS Network Token';\n", "    string public constant symbol = 'DOS';\n", '    uint256 public constant decimals = 18;\n', '    uint256 private constant MAX_SUPPLY = 1e9 * 1e18; // 1 billion total supply\n', '    uint256 private _supply = MAX_SUPPLY;\n', '    \n', '    mapping (address => uint256) _balances;\n', '    mapping (address => mapping (address => uint256))  _approvals;\n', '    \n', '    constructor() public {\n', '        _balances[msg.sender] = _supply;\n', '        emit Transfer(address(0), msg.sender, _supply);\n', '    }\n', '\n', '    function totalSupply() public view returns (uint) {\n', '        return _supply;\n', '    }\n', '    \n', '    function balanceOf(address src) public view returns (uint) {\n', '        return _balances[src];\n', '    }\n', '    \n', '    function allowance(address src, address guy) public view returns (uint) {\n', '        return _approvals[src][guy];\n', '    }\n', '\n', '    function transfer(address dst, uint wad) public returns (bool) {\n', '        return transferFrom(msg.sender, dst, wad);\n', '    }\n', '\n', '    function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {\n', '        require(_balances[src] >= wad, "token-insufficient-balance");\n', '\n', '        // Adjust token transfer amount if necessary.\n', '        if (isContract(manager)) {\n', '            wad = ControllerManager(manager).onTransfer(src, _balances[src], wad);\n', '            require(wad > 0, "transfer-disabled-by-ControllerManager");\n', '        }\n', '\n', '        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {\n', '            require(_approvals[src][msg.sender] >= wad, "token-insufficient-approval");\n', '            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);\n', '        }\n', '\n', '        _balances[src] = sub(_balances[src], wad);\n', '        _balances[dst] = add(_balances[dst], wad);\n', '\n', '        emit Transfer(src, dst, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function approve(address guy) public stoppable returns (bool) {\n', '        return approve(guy, uint(-1));\n', '    }\n', '\n', '    function approve(address guy, uint wad) public stoppable returns (bool) {\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_guy, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((wad == 0) || (_approvals[msg.sender][guy] == 0));\n', '        \n', '        _approvals[msg.sender][guy] = wad;\n', '\n', '        emit Approval(msg.sender, guy, wad);\n', '\n', '        return true;\n', '    }\n', '\n', '    function burn(uint wad) public {\n', '        burn(msg.sender, wad);\n', '    }\n', '    \n', '    function mint(address guy, uint wad) public auth stoppable {\n', '        _balances[guy] = add(_balances[guy], wad);\n', '        _supply = add(_supply, wad);\n', '        require(_supply <= MAX_SUPPLY, "Total supply overflow");\n', '        emit Transfer(address(0), guy, wad);\n', '    }\n', '    \n', '    function burn(address guy, uint wad) public auth stoppable {\n', '        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {\n', '            require(_approvals[guy][msg.sender] >= wad, "token-insufficient-approval");\n', '            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);\n', '        }\n', '\n', '        require(_balances[guy] >= wad, "token-insufficient-balance");\n', '        _balances[guy] = sub(_balances[guy], wad);\n', '        _supply = sub(_supply, wad);\n', '        emit Transfer(guy, address(0), wad);\n', '    }\n', '    \n', "    /// @notice Ether sent to this contract won't be returned, thank you.\n", '    function () external payable {}\n', '\n', '    /// @notice This method can be used by the owner to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token, address payable _dst) public auth {\n', '        if (_token == address(0)) {\n', '            _dst.transfer(address(this).balance);\n', '            return;\n', '        }\n', '\n', '        ERC20 token = ERC20(_token);\n', '        uint balance = token.balanceOf(address(this));\n', '        token.transfer(_dst, balance);\n', '    }\n', '}']