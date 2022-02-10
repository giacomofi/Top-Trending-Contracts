['pragma solidity ^0.6.0;\n', '// "SPDX-License-Identifier: UNLICENSED "\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'The Forms ver.2' token contract\n", '\n', '// Symbol      : FRMS\n', '// Name        : The Forms\n', '// Total supply: 5,898,277\n', '// Decimals    : 18\n', '// ----------------------------------------------------------------------------\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' *\n', '*/\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint a, uint m) internal pure returns (uint r) {\n', '    return (a + m - 1) / m * m;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'abstract contract ERC20Interface {\n', '    function totalSupply() public virtual view returns (uint);\n', '    function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) public virtual view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) public virtual returns (bool success);\n', '    function approve(address spender, uint256 tokens) public virtual returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals and assisted\n', '// token transfers\n', '// ----------------------------------------------------------------------------\n', 'contract Token is ERC20Interface, Owned {\n', '    using SafeMath for uint256;\n', '    string public symbol = "FRMS";\n', '    string public  name = "The Forms";\n', '    uint256 public decimals = 18;\n', '    uint256 private _totalSupply =  5898277 * 10 ** (decimals); \n', '    \n', '    mapping(address => uint256) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', '    address constant private TEAM = 0x24B73DC219196a5E373D73b7Cd638017f1f07E2F;\n', '    address constant private MARKETING_FUNDS = 0x4B63B18b66Fc617B5A3125F0ABB565Dc22d732ba ;\n', '    address constant private COMMUNITY_REWARD = 0xC071C603238F387E48Ee96826a81D608e304545A;\n', '    \n', '    address constant private PRIVATE_SALE_ADD1 = 0xB5Aceaa4db96d6901b492505170Ab7F1d6E7cdAd;\n', '    address constant private PRIVATE_SALE_ADD2 = 0x8f63Fe51A3677cf02C80c11933De4B5846f2a336;\n', '    address constant private PRIVATE_SALE_ADD3 = 0x134D97378Ed04eC0CaE4C689800Be9e96D683ac1;\n', '    \n', '    struct LOCKING{\n', '        uint256 lockedTokens; //DR , //PRC \n', '        uint256 releasePeriod;\n', '        uint256 cliff; //DR, PRC \n', '        uint256 lastVisit;\n', '        uint256 releasePercentage;\n', '        bool directRelease; //DR\n', '    }\n', '    mapping(address => LOCKING) public walletsLocking;\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    constructor() public {\n', '        owner = 0xA6a3E445E613FF022a3001091C7bE274B6a409B0;\n', '        \n', '        _tokenAllocation();\n', '        _setLocking();\n', '        saleOneAllocationsLocking();\n', '        saleTwoAllocationsLocking();\n', '        saleThreeAllocations();\n', '    }\n', '    \n', '    function _tokenAllocation() private {\n', '        // send funds to team\n', '        _allocate(TEAM, 1303625 );\n', '        // send funds to community reward\n', '        _allocate(COMMUNITY_REWARD,1117393 );\n', '        \n', '        // send funds to marketing funds\n', '        _allocate(MARKETING_FUNDS, 964572); \n', '        \n', '        // send funds to owner for uniswap liquidity\n', '        _allocate(owner, 354167 );\n', '        \n', '        // Send to private sale addresses 1\n', '        _allocate(0xB5Aceaa4db96d6901b492505170Ab7F1d6E7cdAd, 529131);\n', '        // Send to private sale addresses 2\n', '        _allocate(0x8f63Fe51A3677cf02C80c11933De4B5846f2a336, 242718 );\n', '        // Send to private sale addresses 3\n', '        _allocate(0x134D97378Ed04eC0CaE4C689800Be9e96D683ac1, 252427 );\n', '    }\n', '    \n', '    function _setLocking() private{\n', '        //////////////////////////////////TEAM////////////////////////////////////\n', '        walletsLocking[TEAM].directRelease = true;\n', '        walletsLocking[TEAM].lockedTokens = 1303625 * 10 ** (decimals);\n', '        walletsLocking[TEAM].cliff = block.timestamp.add(365 days);\n', '        \n', '        //////////////////////////////////PRIVATE SALE ADDRESS 1////////////////////////////////////\n', '        /////////////////////////////0xB5Aceaa4db96d6901b492505170Ab7F1d6E7cdAd////////////////////\n', '        walletsLocking[0xB5Aceaa4db96d6901b492505170Ab7F1d6E7cdAd].directRelease = true;\n', '        walletsLocking[0xB5Aceaa4db96d6901b492505170Ab7F1d6E7cdAd].lockedTokens = 529131 * 10 ** (decimals);\n', '        walletsLocking[0xB5Aceaa4db96d6901b492505170Ab7F1d6E7cdAd].cliff = block.timestamp.add(180 days);\n', '        \n', '        //////////////////////////////////PRIVATE SALE ADDRESS 2////////////////////////////////////\n', '        /////////////////////////////0x8f63Fe51A3677cf02C80c11933De4B5846f2a336////////////////////\n', '        walletsLocking[0x8f63Fe51A3677cf02C80c11933De4B5846f2a336].directRelease = true;\n', '        walletsLocking[0x8f63Fe51A3677cf02C80c11933De4B5846f2a336].lockedTokens = 242718 * 10 ** (decimals);\n', '        walletsLocking[0x8f63Fe51A3677cf02C80c11933De4B5846f2a336].cliff = block.timestamp.add(180 days);\n', '        \n', '        //////////////////////////////////PRIVATE SALE ADDRESS 3////////////////////////////////////\n', '        /////////////////////////////0x134D97378Ed04eC0CaE4C689800Be9e96D683ac1////////////////////\n', '        walletsLocking[0x134D97378Ed04eC0CaE4C689800Be9e96D683ac1].directRelease = true;\n', '        walletsLocking[0x134D97378Ed04eC0CaE4C689800Be9e96D683ac1].lockedTokens = 252427 * 10 ** (decimals);\n', '        walletsLocking[0x134D97378Ed04eC0CaE4C689800Be9e96D683ac1].cliff = block.timestamp.add(180 days);\n', '        \n', '        //////////////////////////////////COMMUNITY_REWARD////////////////////////////////////\n', '        walletsLocking[COMMUNITY_REWARD].directRelease = false;\n', '        walletsLocking[COMMUNITY_REWARD].lockedTokens = 1117393 * 10 ** (decimals);\n', '        walletsLocking[COMMUNITY_REWARD].cliff = block.timestamp.add(30 days);\n', '        walletsLocking[COMMUNITY_REWARD].lastVisit = block.timestamp.add(30 days);\n', '        walletsLocking[COMMUNITY_REWARD].releasePeriod = 30 days; // 1 month\n', '        walletsLocking[COMMUNITY_REWARD].releasePercentage = 5586965e16; // 55869.65\n', '        \n', '        //////////////////////////////////MARKETING_FUNDS////////////////////////////////////\n', '        walletsLocking[MARKETING_FUNDS].directRelease = false;\n', '        walletsLocking[MARKETING_FUNDS].lockedTokens = 7716576e17; // 771657.6\n', '        walletsLocking[MARKETING_FUNDS].cliff = block.timestamp; \n', '        walletsLocking[MARKETING_FUNDS].lastVisit = block.timestamp;\n', '        walletsLocking[MARKETING_FUNDS].releasePeriod = 30 days; // 1 month\n', '        walletsLocking[MARKETING_FUNDS].releasePercentage = 1929144e17; // 192914.4\n', '    }\n', '    \n', '    function saleThreeAllocations() private {\n', '        _allocate(0x2488f090656BddB63fe3Bdb506D0D109AaaD93Bb,58590); \n', '        \n', '        _allocate(0xD7a98d34CD49dd203cAc9752Ea400Ee309A5F602,46872 );\n', '        \n', '        _allocate(0x7b88aD278Cd11506661516E544EcAA9e39F03aF0,39060 );\n', '        \n', '        _allocate(0xc77c3EfB55bd7b0E44c13EB27eb33c98597f0a68,39060 );\n', '        \n', '        _allocate(0x42D455B219214FDA88aF47786CC6e3B5f9a19c37,27342 );\n', '        \n', '        _allocate(0x42D455B219214FDA88aF47786CC6e3B5f9a19c37,19530 );\n', '        \n', '        _allocate(0x42D455B219214FDA88aF47786CC6e3B5f9a19c37,19530 );\n', '        \n', '        _allocate(0xd4Bc360cFDd35e8025dA8237A49D80Fdfb8E351e,17577 );\n', '        \n', '        _allocate(0x707D048708802Dc7730C722F8886105Ff07f0331,15624 );\n', '        \n', '        _allocate(0xfcd987b0D6656c1c84EF73da18c6596D42a73c5E,15624 ); \n', '        \n', '        _allocate(0xa38B4f096Ef6323736D26BF6F9a9Ce1dd2257732,15624 ); \n', '        \n', '        _allocate(0x4b1bA9aA4337e65ffA2155b92BaFd8E177E73CB5,11718 ); \n', '        \n', '        _allocate(0xE8E61Db7918bD88E5ff764Ad5393e87D7AaEf9aD,11718 ); \n', '        \n', '        _allocate(0x28B7677b86be88d432775f1c808a33957f6833BE,11718 ); \n', '        \n', '        _allocate(0x65E27aD821D14E3567E97eb600728d2AAc7e1be4,11718 ); \n', '        \n', '        _allocate(0xDa892C1700147079d0bDeafB7b566E77315f98A4,11718 ); \n', '        \n', '        _allocate(0xb0B743639224d2c82c857E6a504daA207e385Dba,8203 ); \n', '        \n', '        _allocate(0xfce0413BAD4E59f55946669E678EccFe87777777,7812 ); \n', '        \n', '        _allocate(0x78782592D452e92fFFAB8e145201108e97cE36b6,7812 ); \n', '        \n', '        _allocate(0x78782592D452e92fFFAB8e145201108e97cE36b6,7812 ); \n', '        \n', '        _allocate(0x1e36795b5168E574b6EF0f0461CC4026251C533E,7812 ); \n', '        \n', '        _allocate(0x81aA6141923Ea42fCAa763d9857418224d9b025a,7812 ); \n', '        \n', '        _allocate(0xf470bbfeaB9B0d60e21FBd611C5d569df20704CE,7812 ); \n', '        \n', '        _allocate(0x31E985b4f7af6B479148d260309B7BcEcEF0fa7B,7812 ); \n', '        \n', '        _allocate(0x707D048708802Dc7730C722F8886105Ff07f0331,7812 ); \n', '        \n', '        _allocate(0xf2d2a2831f411F5cE863E8f836481dB0b40c03A5,7812 ); \n', '        \n', '        _allocate(0x716C9cC35607040f54b9232D35a2871F46894F58,6000 ); \n', '        \n', '        _allocate(0x81724bCe3D755AEB716d030cbD2c0f5b9f508Df0,5000 ); \n', '        \n', '        _allocate(0xE8CC2a8540C7339430859b8E7902AF2fE2d91865,4687 ); \n', '        \n', '        _allocate(0x268e1fEE56498Cc24758864AA092F870e8220f74,3906 ); \n', '        \n', '        _allocate(0xF93eD4Fe97eB8A2508D03222a28E332F1C89B0eD,3906 ); \n', '        \n', '        _allocate(0x65E27aD821D14E3567E97eb600728d2AAc7e1be4,3906 ); \n', '        \n', '        _allocate(0x001C88d92d199C9EB936Ed3D6758da7C48e4D08e,3906 ); \n', '        \n', '        _allocate(0x42c6Be1400578B238aCd8946FE9682E650DfdE8D,3906 ); \n', '        \n', '        _allocate(0x65E27aD821D14E3567E97eb600728d2AAc7e1be4,3906 ); \n', '        \n', '        _allocate(0xAcb272Eac895FA57394747615fCb068b8858AAF2,3906 ); \n', '        \n', '        \n', '        _allocate(0x21eDE22Cb8Ab64F4F74128f3D0250a7851971A33,3906 ); \n', '        \n', '        _allocate(0x3DFf997410D94E2E3C961F805b85eB2Ef80622c5,3906 ); \n', '        \n', '        _allocate(0x8F70b3aC45A6896532FB90B992D5B7827bA88d3C,3906 ); \n', '        \n', '        _allocate(0xef6D6a51900B5cf220Fe54F8309B6Eda32e794E9,3906 ); \n', '        \n', '        _allocate(0x52BF55C77C402F90dF3Bc1d9E6a0faf262437ab1,3906 ); \n', '        \n', '        _allocate(0xa2639Ef1e7956b242E2C5Ac87b72B077FEbe2783,3906 ); \n', '        \n', '        _allocate(0x716C9cC35607040f54b9232D35a2871F46894F58,3906 ); \n', '        \n', '        _allocate(0x5826914A6223053038328ab3bc7CEB64db04DDc4,3515 ); \n', '        \n', '        _allocate(0x896Fa945c5533631F8DaFE7483FeA6859537cfD0,3125 ); \n', '        \n', '        _allocate(0x2d5304bA4f2c6EFF5D53CecF64AF89818A416cB9,3125 ); \n', '        \n', '        _allocate(0xD53354D4Fb7BcE81Cd4F83c457dbd5EF655C9E93,2734 ); \n', '        \n', '        _allocate(0x49216a6434B75051e9063E99Bb486bc85B0b0605,1953 ); \n', '        \n', '        _allocate(0xD53354D4Fb7BcE81Cd4F83c457dbd5EF655C9E93,1953 ); \n', '        \n', '        _allocate(0x4CEa5d86Bb0bBFa77CB452CCBD52e76dEA4dE045,1627 ); \n', '        \n', '        _allocate(0xC274362c1E85834Eb8387C18168C01aaEe2B00d7,1562 ); \n', '        \n', '        _allocate(0x18A8e216c3406dED40438856B45198B3ce39e522,1367 ); \n', '        \n', '        _allocate(0x51B3954e185869FB4cb9D2Bf9Fbd00A22900E800,477 ); \n', '    }\n', '    \n', '    function saleOneAllocationsLocking() private {\n', '        \n', '        uint256 lockingPeriod = 24 hours;\n', '        _allocateLock(0xCCa178a04D83Af193330C7927fb9a42212Fb1C25, 85932, lockingPeriod);\n', '        _allocateLock(0xD7d7d68E4BDCf85c073485aB7Bfd151B0C019F1F, 39060, lockingPeriod);\n', '        \n', '        _allocateLock(0xf470bbfeaB9B0d60e21FBd611C5d569df20704CE, 31248, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0x9022BC8774AebC343De33423570b5285981bd9E1, 31248, lockingPeriod);\n', '        _allocateLock(0xcf9Bb70b2f1aCCb846e8B0C665a1Ab5D5D35cA05, 31248, lockingPeriod);\n', '        \n', '        _allocateLock(0xfce0413BAD4E59f55946669E678EccFe87777777, 23436, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0xf470bbfeaB9B0d60e21FBd611C5d569df20704CE, 23436, lockingPeriod);\n', '        _allocateLock(0xfEeA4Cd7a96dCffBDc6d2e6c814eb4544ab62667, 23436, lockingPeriod);\n', '        \n', '        _allocateLock(0xb4A0563DE6ABeE9C3C0631FbAE3444F012a40dB5, 19530, lockingPeriod); \n', '\n', '        _allocateLock(0x54a9bB530474d287202Da7f4d5c9756E13f699f3, 15624, lockingPeriod);\n', '        _allocateLock(0xEad249D58E4ebbFBf4ABbeCc1201bD88E50f7967, 15624, lockingPeriod);\n', '        \n', '        _allocateLock(0x3Dd4234DaeefBaBCeAA6068C04C3f75F19aa2cdA, 15624, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0x88F7541D87b7f3c88115A5b2387587263c5d4C7E, 11718, lockingPeriod);\n', '        _allocateLock(0xf3e4D991a20043b6Bd025058CF4d96Fd7501070b, 11718, lockingPeriod);\n', '        \n', '        _allocateLock(0xEc315068A71458FB1A6cC063E9BC7369EC41a7a5, 8593, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0x54a9bB530474d287202Da7f4d5c9756E13f699f3, 7812, lockingPeriod); \n', '        _allocateLock(0x0fEB352cfd10314af9abCF4eD03Da9311Bf8bC44, 7812, lockingPeriod);\n', '        \n', '        _allocateLock(0xd28932b8d4Be295D4B90b514EFa3E80436d66bEC, 7812, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0x268e1fEE56498Cc24758864AA092F870e8220f74, 7812, lockingPeriod);\n', '        _allocateLock(0xDFF214084Fee648c8e0bc0838C1fa5E8548F58aC, 7812, lockingPeriod);\n', '        \n', '        _allocateLock(0x4356DdB30910c1f9b3Aa1e6A60111CE9802B6dF9, 7812, lockingPeriod);  \n', '        \n', '        \n', '        _allocateLock(0x863A3bD6f28f4F4A131c88708dA91076fDC362C7, 7812, lockingPeriod);\n', '        _allocateLock(0x3F79B63823E435FaF08A95e0973b389333B19b99, 7812, lockingPeriod);\n', '        \n', '        _allocateLock(0x8F70b3aC45A6896532FB90B992D5B7827bA88d3C, 7812, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0xEc315068A71458FB1A6cC063E9BC7369EC41a7a5, 6640, lockingPeriod);\n', '        _allocateLock(0x138EcD97Da1C9484263BfADDc1f3D6AE2a435bCb, 6250, lockingPeriod); \n', '        \n', '        _allocateLock(0x53A07d3c1Fdc58c0Cfd2c96817D9537A9E113dd4, 5468, lockingPeriod); \n', '\n', '        _allocateLock(0xCEC0971e55A4C39e3e2C4d8f175CC6e53c138B0A, 4297, lockingPeriod);\n', '        _allocateLock(0xBA682E593784f7654e4F92D58213dc495f229Eec, 3906, lockingPeriod); \n', '        \n', '        _allocateLock(0x9B9e35C223B39f908A036E41011D9E3aDb06ae0B, 3906, lockingPeriod); \n', '        \n', '        \n', '        _allocateLock(0xBA98b69a140c078746219D0bBf0bb3b923483374, 3906, lockingPeriod);\n', '        _allocateLock(0x34c4E14243a95b148534f894FCe86c61bC9F731a, 3906, lockingPeriod);\n', '        \n', '        _allocateLock(0x9A61567A3e3c5b47DFFB0670C629A40533Eb84d5, 3906, lockingPeriod); \n', '        \n', '        _allocateLock(0xda90dDbbdd4e0237C6889367c1556179c817680B, 3567, lockingPeriod); \n', '        _allocateLock(0x329318Ca294A2d127e43058A7b23ED514B503d76, 2734, lockingPeriod);\n', '        \n', '        _allocateLock(0x7B3fC9597f146F0A80FC26dB0DdF62C04ea89740, 2578, lockingPeriod); \n', '        \n', '        _allocateLock(0xb6eC0d0172BC4Cff8fF669b543e03c2c8B64Fc5E, 2344, lockingPeriod);\n', '        \n', '        _allocateLock(0x53A07d3c1Fdc58c0Cfd2c96817D9537A9E113dd4, 2344, lockingPeriod); \n', '        \n', '    }\n', '    \n', '    function saleTwoAllocationsLocking() private {\n', '        \n', '        uint256 lockingPeriod = 12 hours;\n', '        _allocateLock(0xc77c3EfB55bd7b0E44c13EB27eb33c98597f0a68, 16758, lockingPeriod);\n', '        _allocateLock(0x9E817382A12D2b1D15246c4d383bEB8171BCdfA9, 13965, lockingPeriod);\n', '        _allocateLock(0xfF6735CFf3DFED5d68dC3DbeBb0d34c5e815BA09, 11172, lockingPeriod);\n', '        _allocateLock(0x5400087152e436C7C22883d01911868A3C892551, 7820, lockingPeriod);\n', '        _allocateLock(0x974896E96219Dd508100f2Ad58921290655072aD, 5586, lockingPeriod);\n', '        _allocateLock(0x0fEB352cfd10314af9abCF4eD03Da9311Bf8bC44, 5586, lockingPeriod);\n', '        _allocateLock(0x268e1fEE56498Cc24758864AA092F870e8220f74, 5586, lockingPeriod);\n', '        _allocateLock(0xC274362c1E85834Eb8387C18168C01aaEe2B00d7, 4469, lockingPeriod);\n', '        _allocateLock(0x93935316db093A8665E91EE932591F76bf8E5295, 3631, lockingPeriod);\n', '        _allocateLock(0x8bdBF4B19cb840e9Ac9B1eFFc2BfAd47591B5bF2, 2793, lockingPeriod);\n', '    }\n', '    \n', '    function _allocateLock(address user, uint256 tokens, uint256 lockingPeriod) private{\n', '        uint256 startTime = 1599253200; // 4 sep\n', '        walletsLocking[user].directRelease = true;\n', '        walletsLocking[user].lockedTokens = tokens * 10 ** (decimals);\n', '        walletsLocking[user].cliff = startTime.add(lockingPeriod);\n', '        \n', '        _allocate(user, tokens);\n', '    }\n', '    \n', '    function  _allocate(address user, uint256 tokens) private {\n', '        balances[user] = balances[user].add(tokens * 10 ** (decimals)); \n', '        emit Transfer(address(0),user, tokens * 10 ** (decimals));\n', '    }\n', '\n', "    /** ERC20Interface function's implementation **/\n", '\n', '    function totalSupply() public override view returns (uint256){\n', '       return _totalSupply;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public override view returns (uint256 balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint256 tokens) public override returns (bool success) {\n', '        // prevent transfer to 0x0, use burn instead\n', '        require(address(to) != address(0), "Transfer to address 0 not allowed");\n', '        require(balances[msg.sender] >= tokens, "SENDER: insufficient balance");\n', '        \n', '        if (walletsLocking[msg.sender].lockedTokens > 0 ){\n', '            if(walletsLocking[msg.sender].directRelease)\n', '                directRelease(msg.sender);\n', '            else\n', '                checkTime(msg.sender);\n', '        }\n', '        \n', '        require(balances[msg.sender].sub(tokens) >= walletsLocking[msg.sender].lockedTokens, "Please wait for tokens to be released");\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint256 tokens) public override returns (bool success){\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender,spender,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    //\n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success){\n', '        require(tokens <= allowed[from][msg.sender]); //check allowance\n', '        \n', '        // prevent transfer to 0x0, use burn instead\n', '        require(address(to) != address(0), "Transfer to address 0 not allowed");\n', '        require(address(from) != address(0), "Transfer from address 0 not allowed");\n', '        require(balances[from] >= tokens, "SENDER: Insufficient balance");\n', '        \n', '        if (walletsLocking[from].lockedTokens > 0){\n', '            if(walletsLocking[from].directRelease)\n', '                directRelease(from);\n', '            else\n', '                checkTime(from);\n', '        }\n', '        \n', '        require(balances[from].sub(tokens) >= walletsLocking[from].lockedTokens, "Please wait for tokens to be released");\n', '        \n', '        balances[from] = balances[from].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        emit Transfer(from,to,tokens);\n', '        return true;\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public override view returns (uint256 remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    \n', '    // ------------------------------------------------------------------------\n', '    // @dev Internal function that burns an amount of the token from a given account\n', '    // @param _amount The amount that will be burnt\n', '    // @param _account The tokens to burn from\n', '    // can be used from account owner or contract owner\n', '    // ------------------------------------------------------------------------\n', '    function burnTokens(uint256 _amount, address _account) public {\n', '        require(msg.sender == _account || msg.sender == owner, "UnAuthorized");\n', '        require(balances[_account] >= _amount, "Insufficient account balance");\n', '        _totalSupply = _totalSupply.sub(_amount);\n', '        balances[_account] = balances[_account].sub(_amount);\n', '        emit Transfer(_account, address(0), _amount);\n', '    }\n', '    \n', '    function directRelease(address _wallet) private{\n', '        if(block.timestamp > walletsLocking[_wallet].cliff){\n', '            walletsLocking[_wallet].lockedTokens = 0;\n', '        }\n', '    }\n', '    \n', '    function checkTime(address _wallet) private {\n', '        // if cliff is applied\n', '        if(block.timestamp > walletsLocking[_wallet].cliff){\n', '            uint256 timeSpanned = (now.sub(walletsLocking[_wallet].lastVisit)).div(walletsLocking[_wallet].releasePeriod);\n', '            \n', '            // if release period is passed\n', '            if (timeSpanned >= 1){\n', '            \n', '                uint256 released = timeSpanned.mul(walletsLocking[_wallet].releasePercentage);\n', '            \n', '                if (released > walletsLocking[_wallet].lockedTokens){\n', '                    released = walletsLocking[_wallet].lockedTokens;\n', '                }\n', '            \n', '                walletsLocking[_wallet].lastVisit = now;\n', '                walletsLocking[_wallet].lockedTokens = walletsLocking[_wallet].lockedTokens.sub(released);\n', '            }\n', '        }\n', '    }\n', '}']