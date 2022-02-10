['pragma solidity ^0.4.25 ;\n', '\n', 'interface IERC20Token {                                     \n', '    function balanceOf(address owner) external returns (uint256);\n', '    function transfer(address to, uint256 amount) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);\n', '    function decimals() external returns (uint256);\n', '}\n', '\n', '\n', 'contract ITNPOS {\n', '    using SafeMath for uint ; \n', '    IERC20Token public tokenContract ;\n', '    address public owner;\n', '    \n', '    mapping (address => bool) public isMinting ; \n', '    mapping(address => uint256) public mintingAmount ;\n', '    mapping(address => uint256) public mintingStart ; \n', '    \n', '    uint256 public totalMintedAmount = 0 ;\n', '    uint256 public mintingAvailable = 10 * 10**6 * 10 ** 18 ; //10 mil * decimals\n', '    \n', '    uint32 public interestEpoch = 2678400 ; //1% per 31 days or 1 month\n', '    \n', '    uint8 interest = 100 ; //1% interest\n', '    \n', '    bool locked = false ;\n', '    \n', '    constructor(IERC20Token _tokenContract) public {\n', '        tokenContract = _tokenContract ;\n', '        owner = msg.sender ; \n', '    }\n', '    \n', '    modifier canMint() {\n', '        require(totalMintedAmount <= mintingAvailable) ; \n', '        _;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '    \n', '    function destroyOwnership() public onlyOwner {\n', '        owner = address(0) ; \n', '    }\n', '    \n', '    function stopContract() public onlyOwner {\n', '        tokenContract.transfer(msg.sender, tokenContract.balanceOf(address(this))) ;\n', '        msg.sender.transfer(address(this).balance) ;  \n', '    }\n', '    \n', '        \n', '    function lockContract() public onlyOwner returns (bool success) {\n', '        locked = true ; \n', '        return true ; \n', '    }\n', '    \n', '    \n', '    function mint(uint amount) canMint payable public {\n', '        require(isMinting[msg.sender] == false) ;\n', '        require(tokenContract.balanceOf(msg.sender) >= interest);\n', '        require(mintingStart[msg.sender] <= now) ; \n', '        \n', '        tokenContract.transferFrom(msg.sender, address(this), amount) ; \n', '        \n', '        isMinting[msg.sender] = true ; \n', '        mintingAmount[msg.sender] = amount; \n', '        mintingStart[msg.sender] = now ; \n', '    } \n', '    \n', '    function stopMint() public {\n', '        require(mintingStart[msg.sender] <= now) ; \n', '        require(isMinting[msg.sender] == true) ; \n', '        \n', '        isMinting[msg.sender] = false ; \n', '      \n', '        tokenContract.transfer(msg.sender, (mintingAmount[msg.sender] + getMintingReward(msg.sender))) ; \n', '        mintingAmount[msg.sender] = 0 ; \n', '    }\n', '\n', '    \n', '    function getMintingReward(address minter) public view returns (uint256 reward) {\n', '        uint age = getCoinAge(minter) ; \n', '        \n', '        return age/interestEpoch * mintingAmount[msg.sender]/interest ;\n', '    }\n', '    \n', '    function getCoinAge(address minter) public view returns(uint256 age){\n', '        return (now - mintingStart[minter]) ; \n', '    }\n', '    \n', '    function ceil(uint a, uint m) public pure returns (uint ) {\n', '        return ((a + m - 1) / m) * m;\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']