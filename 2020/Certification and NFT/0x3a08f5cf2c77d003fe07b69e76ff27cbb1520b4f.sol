['/*\n', '██╗     ███████╗██╗  ██╗                         \n', '██║     ██╔════╝╚██╗██╔╝                         \n', '██║     █████╗   ╚███╔╝                          \n', '██║     ██╔══╝   ██╔██╗                          \n', '███████╗███████╗██╔╝ ██╗                         \n', '╚══════╝╚══════╝╚═╝  ╚═╝                         \n', ' ██████╗ ██╗   ██╗██╗██╗     ██████╗             \n', '██╔════╝ ██║   ██║██║██║     ██╔══██╗            \n', '██║  ███╗██║   ██║██║██║     ██║  ██║            \n', '██║   ██║██║   ██║██║██║     ██║  ██║            \n', '╚██████╔╝╚██████╔╝██║███████╗██████╔╝            \n', ' ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝             \n', '██╗      ██████╗  ██████╗██╗  ██╗███████╗██████╗ \n', '██║     ██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗\n', '██║     ██║   ██║██║     █████╔╝ █████╗  ██████╔╝\n', '██║     ██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗\n', '███████╗╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║\n', '╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝\n', 'DEAR MSG.SENDER(S):\n', '\n', '/ LXGL is a project in beta.\n', '// Please audit & use at your own risk.\n', '/// Entry into LXGL shall not create an attorney/client relationship.\n', '//// Likewise, LXGL should not be construed as legal advice or replacement for professional counsel.\n', '///// STEAL THIS C0D3SL4W \n', '\n', '~presented by LexDAO | Raid Guild LLC\n', '*/\n', '\n', 'pragma solidity 0.5.17;\n', '\n', 'interface IERC20 { // brief interface for erc20 token txs\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '}\n', '\n', 'interface IWETH { // brief interface for canonical ether token wrapper contract \n', '    function deposit() payable external;\n', '    \n', '    function transfer(address dst, uint wad) external returns (bool);\n', '}\n', '\n', 'library Address { // helper for address type / openzeppelin-contracts/blob/master/contracts/utils/Address.sol\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '}\n', '\n', 'library SafeERC20 { // wrapper around erc20 token txs for non-standard contracts / openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol\n', '    using Address for address;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '   function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        require(address(token).isContract(), "SafeERC20: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = address(token).call(data);\n', '        require(success, "SafeERC20: low-level call failed");\n', '\n', '        if (returndata.length > 0) { // return data is optional\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: erc20 operation did not succeed");\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath { // wrapper over solidity arithmetic for unit under/overflow checks\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '    \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Context { // describes current contract execution context (metaTX support) / openzeppelin-contracts/blob/master/contracts/GSN/Context.sol\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract LexGuildLocker is Context { // splittable digital deal lockers w/ embedded arbitration tailored for guild work\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    /** <$> LXGL <$> **/\n', '    address public lexDAO;\n', '    address public wETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // canonical ether token wrapper contract reference\n', '    uint256 public lockerCount;\n', '    uint256 public MAX_DURATION; // time limit on token lockup - default 63113904 (2-year)\n', '    uint256 public resolutionRate;\n', '    mapping(uint256 => Locker) public lockers; \n', '\n', '    struct Locker {  \n', '        address client; \n', '        address[] provider;\n', '        address resolver;\n', '        address token;\n', '        uint8 confirmed;\n', '        uint8 locked;\n', '        uint256[] batch;\n', '        uint256 cap;\n', '        uint256 released;\n', '        uint256 termination;\n', '        bytes32 details; \n', '    }\n', '    \n', '    event RegisterLocker(address indexed client, address[] indexed provider, address indexed resolver, address token, uint256[] batch, uint256 cap, uint256 index, uint256 termination, bytes32 details);\t\n', '    event ConfirmLocker(uint256 indexed index, uint256 indexed sum);  \n', '    event Release(uint256 indexed index, uint256[] indexed milestone); \n', '    event Withdraw(uint256 indexed index, uint256 indexed remainder);\n', '    event Lock(address indexed sender, uint256 indexed index, bytes32 indexed details);\n', '    event Resolve(address indexed resolver, uint256 indexed clientAward, uint256[] indexed providerAward, uint256 index, uint256 resolutionFee, bytes32 details); \n', '    event UpdateLockerSettings(address indexed lexDAO, uint256 indexed MAX_DURATION, uint256 indexed resolutionRate, bytes32 details);\n', '    \n', '    constructor (address _lexDAO, uint256 _MAX_DURATION, uint256 _resolutionRate) public {\n', '        lexDAO = _lexDAO;\n', '        MAX_DURATION = _MAX_DURATION;\n', '        resolutionRate = _resolutionRate;\n', '    }\n', '\n', '    /***************\n', '    LOCKER FUNCTIONS\n', '    ***************/\n', '    function registerLocker( // register locker for token deposit & client deal confirmation\n', '        address client,\n', '        address[] calldata provider,\n', '        address resolver,\n', '        address token,\n', '        uint256[] calldata batch, \n', '        uint256 cap,\n', '        uint256 milestones,\n', '        uint256 termination, // exact termination date in seconds since epoch\n', '        bytes32 details) external returns (uint256) {\n', '        uint256 sum;\n', '        for (uint256 i = 0; i < provider.length; i++) {\n', '            sum = sum.add(batch[i]);\n', '        }\n', '        \n', '        require(sum.mul(milestones) == cap, "deposit != milestones");\n', '        require(termination <= now.add(MAX_DURATION), "duration maxed");\n', '        \n', '        lockerCount = lockerCount + 1;\n', '        uint256 index = lockerCount;\n', '        \n', '        lockers[index] = Locker( \n', '            client, \n', '            provider,\n', '            resolver,\n', '            token,\n', '            0,\n', '            0,\n', '            batch,\n', '            cap,\n', '            0,\n', '            termination,\n', '            details);\n', '\n', '        emit RegisterLocker(client, provider, resolver, token, batch, cap, index, termination, details); \n', '        return index;\n', '    }\n', '    \n', '    function confirmLocker(uint256 index) payable external { // client confirms deposit of cap & locks in deal\n', '        Locker storage locker = lockers[index];\n', '        \n', '        require(locker.confirmed == 0, "confirmed");\n', '        require(_msgSender() == locker.client, "!client");\n', '        \n', '        uint256 sum = locker.cap;\n', '        \n', '        if (locker.token == wETH && msg.value > 0) {\n', '            require(msg.value == sum, "!ETH");\n', '            IWETH(wETH).deposit();\n', '            (bool success, ) = wETH.call.value(msg.value)("");\n', '            require(success, "!transfer");\n', '            IWETH(wETH).transfer(address(this), msg.value);\n', '        } else {\n', '            IERC20(locker.token).safeTransferFrom(msg.sender, address(this), sum);\n', '        }\n', '        \n', '        locker.confirmed = 1;\n', '        \n', '        emit ConfirmLocker(index, sum); \n', '    }\n', '\n', '    function release(uint256 index) external { // client transfers locker milestone batch to provider(s) \n', '    \tLocker storage locker = lockers[index];\n', '\t    \n', '\t    require(_msgSender() == locker.client, "!client");\n', '\t    require(locker.confirmed == 1, "!confirmed");\n', '\t    require(locker.locked == 0, "locked");\n', '\t    require(locker.cap > locker.released, "released");\n', '        \n', '        uint256[] memory milestone = locker.batch;\n', '        \n', '        for (uint256 i = 0; i < locker.provider.length; i++) {\n', '            IERC20(locker.token).safeTransfer(locker.provider[i], milestone[i]);\n', '            locker.released = locker.released.add(milestone[i]);\n', '        }\n', '\n', '\t    emit Release(index, milestone); \n', '    }\n', '    \n', '    function withdraw(uint256 index) external { // withdraw locker remainder to client if termination time passes & no lock\n', '    \tLocker storage locker = lockers[index];\n', '        \n', '        require(locker.confirmed == 1, "!confirmed");\n', '        require(locker.locked == 0, "locked");\n', '        require(locker.cap > locker.released, "released");\n', '        require(now > locker.termination, "!terminated");\n', '        \n', '        uint256 remainder = locker.cap.sub(locker.released); \n', '        \n', '        IERC20(locker.token).safeTransfer(locker.client, remainder);\n', '        \n', '        locker.released = locker.released.add(remainder); \n', '        \n', '\t    emit Withdraw(index, remainder); \n', '    }\n', '    \n', '    /************\n', '    ADR FUNCTIONS\n', '    ************/\n', '    function lock(uint256 index, bytes32 details) external { // client or main (0) provider can lock remainder for resolution during locker period / update request details\n', '        Locker storage locker = lockers[index]; \n', '        \n', '        require(locker.confirmed == 1, "!confirmed");\n', '        require(locker.cap > locker.released, "released");\n', '        require(now < locker.termination, "terminated"); \n', '        require(_msgSender() == locker.client || _msgSender() == locker.provider[0], "!party"); \n', '\n', '\t    locker.locked = 1; \n', '\t    \n', '\t    emit Lock(_msgSender(), index, details);\n', '    }\n', '    \n', '    function resolve(uint256 index, uint256 clientAward, uint256[] calldata providerAward, bytes32 details) external { // resolver splits locked deposit remainder between client & provider(s)\n', '        Locker storage locker = lockers[index];\n', '        \n', '        uint256 remainder = locker.cap.sub(locker.released); \n', '\t    uint256 resolutionFee = remainder.div(resolutionRate); // calculate dispute resolution fee\n', '\t    \n', '\t    require(locker.locked == 1, "!locked"); \n', '\t    require(locker.cap > locker.released, "released");\n', '\t    require(_msgSender() != locker.client, "resolver == client");\n', '\t    require(_msgSender() == locker.resolver, "!resolver");\n', '\t    \n', '\t    for (uint256 i = 0; i < locker.provider.length; i++) {\n', '            require(msg.sender != locker.provider[i], "resolver == provider");\n', '            require(clientAward.add(providerAward[i]) == remainder.sub(resolutionFee), "resolution != remainder");\n', '            IERC20(locker.token).safeTransfer(locker.provider[i], providerAward[i]);\n', '        }\n', '  \n', '        IERC20(locker.token).safeTransfer(locker.client, clientAward);\n', '        IERC20(locker.token).safeTransfer(locker.resolver, resolutionFee);\n', '\t    \n', '\t    locker.released = locker.released.add(remainder); \n', '\t    \n', '\t    emit Resolve(_msgSender(), clientAward, providerAward, index, resolutionFee, details);\n', '    }\n', '    \n', '    /**************\n', '    LEXDAO FUNCTION\n', '    **************/\n', '    function updateLockerSettings(address _lexDAO, uint256 _MAX_DURATION, uint256 _resolutionRate, bytes32 details) external { \n', '        require(_msgSender() == lexDAO, "!lexDAO");\n', '        \n', '        lexDAO = _lexDAO;\n', '        MAX_DURATION = _MAX_DURATION;\n', '        resolutionRate = _resolutionRate;\n', '\t    \n', '\t    emit UpdateLockerSettings(lexDAO, MAX_DURATION, resolutionRate, details);\n', '    }\n', '}']