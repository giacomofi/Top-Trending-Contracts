['pragma solidity 0.4.24;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Interface {\n', '     function totalSupply() public constant returns (uint);\n', '     function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) public returns (bool success);\n', '     function approve(address spender, uint tokens) public returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '     function mint(address from, address to, uint tokens) public;\n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', 'contract AdvertisementContract {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    struct Advertisement {\n', '      address advertiser;\n', '      uint advertisementId;\n', '      string advertisementLink;\n', '      uint amountToBePaid;\n', '      //Voter[] voterList;\n', '      bool isUnlocked;    \n', '    }\n', '\n', '    struct Voter {\n', '      address publicKey;\n', '      uint amountEarned;  \n', '    }\n', '    \n', '    \n', '    struct VoteAdvertisementPayoutScheme {\n', '      uint voterPercentage; \n', '      uint systemPercentage;  \n', '    }\n', '    \n', '    // The token that would be sold using this contract \n', '    ERC20Interface public token;\n', '    //Objects for use within program\n', '    \n', '    VoteAdvertisementPayoutScheme voteAdvertismentPayoutSchemeObj;\n', '    Advertisement advertisement;\n', '    Voter voter;\n', '    uint counter = 0;\n', '    address public wallet;\n', '    \n', '    mapping (uint=>Voter[]) advertisementVoterList;\n', '    \n', '    mapping (uint=>Advertisement) advertisementList;\n', '    \n', '    uint localIntAsPerNeed;\n', '    address localAddressAsPerNeed;\n', '    Voter[] voters;\n', '   \n', '    constructor(address _wallet,address _tokenAddress) public {\n', '      wallet = _wallet;\n', '      token = ERC20Interface(_tokenAddress);\n', '      setup();\n', '    }\n', '        \n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '    \n', '   \n', '    function setup() internal {\n', '        voteAdvertismentPayoutSchemeObj = VoteAdvertisementPayoutScheme({voterPercentage: 79, systemPercentage: 21});\n', '    }\n', '    \n', '    function uploadAdvertisement(uint adId,string advLink, address advertiserAddress, uint uploadTokenAmount) public\n', '    {\n', '        require(msg.sender == wallet);\n', '        token.mint(advertiserAddress,wallet,uploadTokenAmount*10**18);    //tokens deducted from advertiser&#39;s wallet\n', '        advertisement = Advertisement({\n', '            advertiser : advertiserAddress,\n', '            advertisementId : adId,\n', '            advertisementLink : advLink,\n', '            amountToBePaid : uploadTokenAmount*10**18,\n', '            isUnlocked : false\n', '        });\n', '        advertisementList[adId] = advertisement;\n', '    }\n', '    \n', '    function AdvertisementPayout (uint advId) public\n', '    {\n', '        require(msg.sender == wallet);\n', '        require(token.balanceOf(wallet)>=advertisementList[advId].amountToBePaid);\n', '        require(advertisementList[advId].advertisementId == advId);\n', '        require(advertisementList[advId].isUnlocked == true);\n', '        require(advertisementList[advId].amountToBePaid > 0);\n', '        uint j = 0;\n', '        \n', '        //calculating voters payout\n', '        voters = advertisementVoterList[advertisementList[advId].advertisementId];\n', '        localIntAsPerNeed = voteAdvertismentPayoutSchemeObj.voterPercentage;\n', '        uint voterPayout = advertisementList[advId].amountToBePaid.mul(localIntAsPerNeed);\n', '        voterPayout = voterPayout.div(100);\n', '        uint perVoterPayout = voterPayout.div(voters.length);\n', '        \n', '        //calculating system payout\n', '        localIntAsPerNeed = voteAdvertismentPayoutSchemeObj.systemPercentage;\n', '        uint systemPayout = advertisementList[advId].amountToBePaid.mul(localIntAsPerNeed);\n', '        systemPayout = systemPayout.div(100);\n', '        \n', '        \n', '        //doing voter payout\n', '        for (j=0;j<voters.length;j++)\n', '        {\n', '            token.mint(wallet,voters[j].publicKey,perVoterPayout);\n', '            voters[j].amountEarned = voters[j].amountEarned.add(perVoterPayout);\n', '            advertisementList[advId].amountToBePaid = advertisementList[advId].amountToBePaid.sub(perVoterPayout);\n', '        }\n', '        //logString("Voter payout done");\n', '        \n', '        //catering for system payout (not trnasferring tokens as the wallet is where all tokens are already)\n', '        advertisementList[advId].amountToBePaid = advertisementList[advId].amountToBePaid.sub(systemPayout);\n', '        //logString("System payout done");     \n', '                 \n', '        require(advertisementList[advId].amountToBePaid == 0);\n', '                \n', '    }\n', '    \n', '   function VoteAdvertisement(uint adId, address voterPublicKey) public \n', '   {\n', '        require(advertisementList[adId].advertisementId == adId);\n', '        require(advertisementList[adId].isUnlocked == false);\n', '        //logString("advertisement found");\n', '        voter = Voter({publicKey: voterPublicKey, amountEarned : 0});\n', '        advertisementVoterList[adId].push(voter);\n', '        //logString("Vote added");\n', '    }\n', '    function unlockAdvertisement(uint adId) public\n', '    {\n', '        require(msg.sender == wallet);\n', '        require(advertisementList[adId].advertisementId == adId);\n', '        advertisementList[adId].isUnlocked = true;\n', '    }\n', '    function getTokenBalance() public constant returns (uint) {\n', '        return token.balanceOf(msg.sender);\n', '    }\n', '\n', '    function changeWalletAddress(address newWallet) public  \n', '    {\n', '        require(msg.sender == wallet);\n', '        wallet = newWallet;\n', '    }\n', '}']