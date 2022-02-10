['pragma solidity ^0.6.6;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  \n', '  constructor() public {\n', '      owner = msg.sender;\n', '  }\n', '\n', '  event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '  modifier onlyOwner {\n', '    assert(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    require(_newOwner != owner, "Cannot transfer to yourself");\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'interface ERC20 {\n', '    function balanceOf(address target) external returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (uint256);\n', '}\n', 'interface AragonFinance {\n', '    function deposit(address _token, uint256 _amount, string calldata _reference) external;\n', '}\n', '\n', 'interface Marketplace {\n', '    function transferOwnership(address) external;\n', '    function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) external;\n', '    function pause() external;\n', '    function unpause() external;\n', '}\n', '\n', 'contract MANACollect is Ownable {\n', '\n', '    Marketplace public marketplace;\n', '    Marketplace public bidMarketplace;\n', '    AragonFinance public aragonFinance;\n', '    ERC20 public mana;\n', '\n', '    constructor(address manaAddress,\n', '        address _marketAddress,\n', '        address _bidAddress,\n', '        address _aragonFinance\n', '    ) public {\n', '        mana = ERC20(manaAddress);\n', '        marketplace = Marketplace(_marketAddress);\n', '        bidMarketplace = Marketplace(_bidAddress);\n', '        aragonFinance = AragonFinance(_aragonFinance);\n', '    }\n', '\n', '    function claimTokens() public {\n', '        uint256 balance = mana.balanceOf(address(this));\n', '        mana.approve(address(aragonFinance), balance);\n', '        aragonFinance.deposit(address(mana), balance, "Fees collected from Marketplace");\n', '    }\n', '\n', '    function transferMarketplaceOwnership(address target) public onlyOwner {\n', '        marketplace.transferOwnership(target);\n', '    }\n', '\n', '    function transferBidMarketplaceOwnership(address target) public onlyOwner {\n', '        bidMarketplace.transferOwnership(target);\n', '    }\n', '\n', '    function setOwnerCutPerMillion(uint256 _ownerCutPerMillion) public onlyOwner {\n', '        marketplace.setOwnerCutPerMillion(_ownerCutPerMillion);\n', '    }\n', '\n', '    function setBidOwnerCutPerMillion(uint256 _ownerCutPerMillion) public onlyOwner {\n', '        bidMarketplace.setOwnerCutPerMillion(_ownerCutPerMillion);\n', '    }\n', '\n', '    function pause() public onlyOwner {\n', '        marketplace.pause();\n', '    }\n', '\n', '    function unpause() public onlyOwner {\n', '        marketplace.unpause();\n', '    }\n', '\n', '    function pauseBid() public onlyOwner {\n', '        bidMarketplace.pause();\n', '    }\n', '\n', '    function unpauseBid() public onlyOwner {\n', '        bidMarketplace.unpause();\n', '    }\n', '}']