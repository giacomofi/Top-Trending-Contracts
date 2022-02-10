['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  function Ownable() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '\n', '  }\n', '}\n', '\n', '// File: contracts/Deployer.sol\n', '\n', 'contract Deployer {\n', '\n', '  address public deployer;\n', '\n', '  function Deployer() public { deployer = msg.sender; }\n', '\n', '  modifier onlyDeployer() {\n', '    require(msg.sender == deployer);\n', '    _;\n', '  }\n', '}\n', '\n', '// File: contracts/ModultradeStorage.sol\n', '\n', 'contract ModultradeStorage is Ownable, Deployer {\n', '\n', '  bool private _doMigrate = true;\n', '\n', '  mapping (address => address[]) public sellerProposals;\n', '\n', '  mapping (uint => address) public proposalListAddress;\n', '\n', '  address[] public proposals;\n', '\n', '  event InsertProposalEvent (address _proposal, uint _id, address _seller);\n', '\n', '  event PaidProposalEvent (address _proposal, uint _id);\n', '\n', '  function ModultradeStorage() public {}\n', '\n', '  function insertProposal(address seller, uint id, address proposal) public onlyOwner {\n', '    sellerProposals[seller].push(proposal);\n', '    proposalListAddress[id] = proposal;\n', '    proposals.push(proposal);\n', '\n', '    InsertProposalEvent(proposal, id, seller);\n', '  }\n', '\n', '  function getProposalsBySeller(address seller) public constant returns (address[]){\n', '    return sellerProposals[seller];\n', '  }\n', '\n', '  function getProposals() public constant returns (address[]){\n', '    return proposals;\n', '  }\n', '\n', '  function getProposalById(uint id) public constant returns (address){\n', '    return proposalListAddress[id];\n', '  }\n', '\n', '  function getCount() public constant returns (uint) {\n', '    return proposals.length;\n', '  }\n', '\n', '  function getCountBySeller(address seller) public constant returns (uint) {\n', '    return sellerProposals[seller].length;\n', '  }\n', '\n', '  function firePaidProposalEvent(address proposal, uint id) public {\n', '    require(proposalListAddress[id] == proposal);\n', '\n', '    PaidProposalEvent(proposal, id);\n', '  }\n', '\n', '  function changeOwner(address newOwner) public onlyDeployer {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  function Ownable() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '\n', '  }\n', '}\n', '\n', '// File: contracts/Deployer.sol\n', '\n', 'contract Deployer {\n', '\n', '  address public deployer;\n', '\n', '  function Deployer() public { deployer = msg.sender; }\n', '\n', '  modifier onlyDeployer() {\n', '    require(msg.sender == deployer);\n', '    _;\n', '  }\n', '}\n', '\n', '// File: contracts/ModultradeStorage.sol\n', '\n', 'contract ModultradeStorage is Ownable, Deployer {\n', '\n', '  bool private _doMigrate = true;\n', '\n', '  mapping (address => address[]) public sellerProposals;\n', '\n', '  mapping (uint => address) public proposalListAddress;\n', '\n', '  address[] public proposals;\n', '\n', '  event InsertProposalEvent (address _proposal, uint _id, address _seller);\n', '\n', '  event PaidProposalEvent (address _proposal, uint _id);\n', '\n', '  function ModultradeStorage() public {}\n', '\n', '  function insertProposal(address seller, uint id, address proposal) public onlyOwner {\n', '    sellerProposals[seller].push(proposal);\n', '    proposalListAddress[id] = proposal;\n', '    proposals.push(proposal);\n', '\n', '    InsertProposalEvent(proposal, id, seller);\n', '  }\n', '\n', '  function getProposalsBySeller(address seller) public constant returns (address[]){\n', '    return sellerProposals[seller];\n', '  }\n', '\n', '  function getProposals() public constant returns (address[]){\n', '    return proposals;\n', '  }\n', '\n', '  function getProposalById(uint id) public constant returns (address){\n', '    return proposalListAddress[id];\n', '  }\n', '\n', '  function getCount() public constant returns (uint) {\n', '    return proposals.length;\n', '  }\n', '\n', '  function getCountBySeller(address seller) public constant returns (uint) {\n', '    return sellerProposals[seller].length;\n', '  }\n', '\n', '  function firePaidProposalEvent(address proposal, uint id) public {\n', '    require(proposalListAddress[id] == proposal);\n', '\n', '    PaidProposalEvent(proposal, id);\n', '  }\n', '\n', '  function changeOwner(address newOwner) public onlyDeployer {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}']
