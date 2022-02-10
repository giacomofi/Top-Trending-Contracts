['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', 'import "./ERC20.sol";\n', '\n', 'contract PolkaDex is ERC20 {\n', '    address payable Owner;\n', '    uint256  immutable InitialBlockNumber ;\n', '\n', '    constructor() ERC20("Polkadex", "PDEX") {\n', '        mainHolder();\n', '        Owner = msg.sender;\n', '        InitialBlockNumber = block.number;\n', '    }\n', '\n', '    function ClaimAfterVesting() public {\n', '        // The second tranch of vesting happens after 3 months (1 quarter = (3*30*24*60*60)/13.14 blocks) from TGE\n', '        require(block.number > InitialBlockNumber + 591781, "Time to claim vested tokens has not reached");\n', '        require(VestedTokens[msg.sender] > 0, "You are not eligible for claim");\n', '        _mint(msg.sender, VestedTokens[msg.sender]);\n', '        VestedTokens[msg.sender] = 0;\n', '    }\n', '\n', '    modifier OnlyOwner {\n', '        require(msg.sender == Owner, "unauthorized access");\n', '        _;\n', '    }\n', '    function TransferOwnerShip(address payable NewAddress) public OnlyOwner {\n', '        require(NewAddress!=address(0),"TransferOwnerShip Denied");\n', '        Owner = NewAddress;\n', '    }\n', '\n', '    function ShowOwner() public view returns (address) {\n', '        return Owner;\n', '    }\n', '}']