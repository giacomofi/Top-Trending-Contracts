['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'interface IEthItem {\n', '\n', '    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;\n', '\n', '    function burnBatch(\n', '        uint256[] calldata objectIds,\n', '        uint256[] calldata amounts\n', '    ) external;\n', '}']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'import "./IERC1155Receiver.sol";\n', 'import "./ERC165.sol";\n', 'import "./IEthItem.sol";\n', '\n', 'contract WhereIsMyDragonTreasure is IERC1155Receiver, ERC165 {\n', '\n', '    address private _source;\n', '    uint256 private _legendaryCard;\n', '\n', '    uint256 private _singleReward;\n', '    uint256 private _legendaryCardAmount;\n', '    uint256 private _startBlock;\n', '\n', '    uint256 private _redeemed;\n', '\n', '    constructor(address source, uint256 legendaryCard, uint256 legendaryCardAmount, uint256 startBlock) {\n', '        _source = source;\n', '        _legendaryCard = legendaryCard;\n', '        _legendaryCardAmount = legendaryCardAmount;\n', '        _startBlock = startBlock;\n', '        _registerInterfaces();\n', '    }\n', '\n', '    function _registerInterfaces() private {\n', '        _registerInterface(this.onERC1155Received.selector);\n', '        _registerInterface(this.onERC1155BatchReceived.selector);\n', '    }\n', '\n', '    receive() external payable {\n', '        if(block.number >= _startBlock) {\n', '            payable(msg.sender).transfer(msg.value);\n', '            return;\n', '        }\n', '        _singleReward = address(this).balance / _legendaryCardAmount;\n', '    }\n', '\n', '    function data() public view returns(uint256 balance, uint256 singleReward, uint256 startBlock, uint256 redeemed) {\n', '        balance = address(this).balance;\n', '        singleReward = _singleReward;\n', '        startBlock = _startBlock;\n', '        redeemed = _redeemed;\n', '    }\n', '\n', '    function onERC1155Received(\n', '        address,\n', '        address from,\n', '        uint256 objectId,\n', '        uint256 amount,\n', '        bytes memory\n', '    )\n', '        public override\n', '        returns(bytes4) {\n', '        uint256[] memory objectIds = new uint256[](1);\n', '        objectIds[0] = objectId;\n', '        uint256[] memory amounts = new uint256[](1);\n', '        amounts[0] = amount;\n', '        _checkBurnAndTransfer(from, objectIds, amounts);\n', '        return this.onERC1155Received.selector;\n', '    }\n', '\n', '    function onERC1155BatchReceived(\n', '        address,\n', '        address from,\n', '        uint256[] memory objectIds,\n', '        uint256[] memory amounts,\n', '        bytes memory\n', '    )\n', '        public override\n', '        returns(bytes4) {\n', '        _checkBurnAndTransfer(from, objectIds, amounts);\n', '        return this.onERC1155BatchReceived.selector;\n', '    }\n', '\n', '    function _checkBurnAndTransfer(address from, uint256[] memory objectIds, uint256[] memory amounts) private {\n', '        require(msg.sender == _source, "Unauthorized Action");\n', '        require(block.number >= _startBlock, "Redeem Period still not started");\n', '        for(uint256 i = 0; i < objectIds.length; i++) {\n', '            require(objectIds[i] == _legendaryCard, "Wrong Card!");\n', '            _redeemed += amounts[i];\n', '            payable(from).transfer(_singleReward * amounts[i]);\n', '        }\n', '        IEthItem(_source).burnBatch(objectIds, amounts);\n', '    }\n', '}']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'interface IERC165 {\n', '    function supportsInterface(bytes4 interfaceId) external view returns (bool);\n', '}']
['//SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'import "./IERC165.sol";\n', '\n', 'interface IERC1155Receiver is IERC165 {\n', '\n', '    function onERC1155Received(\n', '        address operator,\n', '        address from,\n', '        uint256 id,\n', '        uint256 value,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '\n', '    function onERC1155BatchReceived(\n', '        address operator,\n', '        address from,\n', '        uint256[] calldata ids,\n', '        uint256[] calldata values,\n', '        bytes calldata data\n', '    )\n', '        external\n', '        returns(bytes4);\n', '}']
['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.4;\n', '\n', 'import "./IERC165.sol";\n', '\n', 'abstract contract ERC165 is IERC165 {\n', '\n', '    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;\n', '\n', '    mapping(bytes4 => bool) private _supportedInterfaces;\n', '\n', '    constructor () {\n', '        _registerInterface(_INTERFACE_ID_ERC165);\n', '    }\n', '\n', '    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {\n', '        return _supportedInterfaces[interfaceId];\n', '    }\n', '\n', '    function _registerInterface(bytes4 interfaceId) internal virtual {\n', '        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");\n', '        _supportedInterfaces[interfaceId] = true;\n', '    }\n', '}']
