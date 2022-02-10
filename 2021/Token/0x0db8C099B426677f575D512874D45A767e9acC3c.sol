['// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity 0.8.3;\n', '\n', 'import "./ERC1155MintBurnPackedBalance.sol";\n', 'import "../interfaces/IERC1155Metadata.sol";\n', '\n', 'contract NFT is ERC1155MintBurnPackedBalance, IERC1155Metadata {\n', '\n', '    address public owner;\n', '    string public baseURI;\n', '\n', '    constructor(string memory _baseURI) {\n', '        owner = msg.sender;\n', '        baseURI = _baseURI;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "not allowed");\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '    }\n', '\n', '    function changeBaseURI(string memory _newBaseURI) public onlyOwner {\n', '        baseURI = _newBaseURI;\n', '    }\n', '\n', '    function mint(address _to, uint256 _id, uint256 _amount) public onlyOwner {\n', '        _mint(_to, _id, _amount, "");\n', '    }\n', '\n', '    function batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts) public onlyOwner {\n', '        _batchMint(_to, _ids, _amounts, "");\n', '    }\n', '\n', '    function burn(address _from, uint256 _id, uint256 _amount) public onlyOwner {\n', '        _burn(_from, _id, _amount);\n', '    }\n', '\n', '    function batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts) public onlyOwner {\n', '        _batchBurn(_from, _ids, _amounts);\n', '    }\n', '\n', '    function supportsInterface(bytes4 _interfaceID) public override pure returns (bool) {\n', '        if (_interfaceID == type(IERC1155).interfaceId || _interfaceID == type(IERC1155Metadata).interfaceId) {\n', '            return true;\n', '        }\n', '        return super.supportsInterface(_interfaceID);\n', '    }\n', '\n', '    function uri(uint256 _id) external view override returns (string memory) {\n', '        return string(abi.encodePacked(baseURI, uint2str(_id)));\n', '    }\n', '\n', '    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {\n', '        if (_i == 0) {\n', '            return "0";\n', '        }\n', '        uint j = _i;\n', '        uint len;\n', '        while (j != 0) {\n', '            len++;\n', '            j /= 10;\n', '        }\n', '        bytes memory bstr = new bytes(len);\n', '        uint k = len;\n', '        while (_i != 0) {\n', '            k = k-1;\n', '            uint8 temp = (48 + uint8(_i - _i / 10 * 10));\n', '            bytes1 b1 = bytes1(temp);\n', '            bstr[k] = b1;\n', '            _i /= 10;\n', '        }\n', '        return string(bstr);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity 0.8.3;\n', '\n', 'import "./ERC1155PackedBalance.sol";\n', '\n', '\n', '/**\n', ' * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume\n', ' *      a parent contract to be executed as they are `internal` functions.\n', ' */\n', 'contract ERC1155MintBurnPackedBalance is ERC1155PackedBalance {\n', '\n', '  /****************************************|\n', '  |            Minting Functions           |\n', '  |_______________________________________*/\n', '\n', '  /**\n', '   * @notice Mint _amount of tokens of a given id\n', '   * @param _to      The address to mint tokens to\n', '   * @param _id      Token id to mint\n', '   * @param _amount  The amount to be minted\n', '   * @param _data    Data to pass if receiver is contract\n', '   */\n', '  function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)\n', '    internal\n', '  {\n', '    //Add _amount\n', '    _updateIDBalance(_to,   _id, _amount, Operations.Add); // Add amount to recipient\n', '\n', '    // Emit event\n', '    emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);\n', '\n', '    // Calling onReceive method if recipient is contract\n', '    _callonERC1155Received(address(0x0), _to, _id, _amount, gasleft(), _data);\n', '  }\n', '\n', '  /**\n', '   * @notice Mint tokens for each (_ids[i], _amounts[i]) pair\n', '   * @param _to       The address to mint tokens to\n', '   * @param _ids      Array of ids to mint\n', '   * @param _amounts  Array of amount of tokens to mint per id\n', '   * @param _data    Data to pass if receiver is contract\n', '   */\n', '  function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)\n', '    internal\n', '  {\n', '    require(_ids.length == _amounts.length, "ERC1155MintBurnPackedBalance#_batchMint: INVALID_ARRAYS_LENGTH");\n', '\n', '    if (_ids.length > 0) {\n', '      // Load first bin and index where the token ID balance exists\n', '      (uint256 bin, uint256 index) = getIDBinIndex(_ids[0]);\n', '\n', '      // Balance for current bin in memory (initialized with first transfer)\n', '      uint256 balTo = _viewUpdateBinValue(balances[_to][bin], index, _amounts[0], Operations.Add);\n', '\n', '      // Number of transfer to execute\n', '      uint256 nTransfer = _ids.length;\n', '\n', '      // Last bin updated\n', '      uint256 lastBin = bin;\n', '\n', '      for (uint256 i = 1; i < nTransfer; i++) {\n', '        (bin, index) = getIDBinIndex(_ids[i]);\n', '\n', '        // If new bin\n', '        if (bin != lastBin) {\n', '          // Update storage balance of previous bin\n', '          balances[_to][lastBin] = balTo;\n', '          balTo = balances[_to][bin];\n', '\n', '          // Bin will be the most recent bin\n', '          lastBin = bin;\n', '        }\n', '\n', '        // Update memory balance\n', '        balTo = _viewUpdateBinValue(balTo, index, _amounts[i], Operations.Add);\n', '      }\n', '\n', '      // Update storage of the last bin visited\n', '      balances[_to][bin] = balTo;\n', '    }\n', '\n', '    // //Emit event\n', '    emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);\n', '\n', '    // Calling onReceive method if recipient is contract\n', '    _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, gasleft(), _data);\n', '  }\n', '\n', '\n', '  /****************************************|\n', '  |            Burning Functions           |\n', '  |_______________________________________*/\n', '\n', '  /**\n', '   * @notice Burn _amount of tokens of a given token id\n', '   * @param _from    The address to burn tokens from\n', '   * @param _id      Token id to burn\n', '   * @param _amount  The amount to be burned\n', '   */\n', '  function _burn(address _from, uint256 _id, uint256 _amount)\n', '    internal\n', '  {\n', '    // Substract _amount\n', '    _updateIDBalance(_from, _id, _amount, Operations.Sub);\n', '\n', '    // Emit event\n', '    emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);\n', '  }\n', '\n', '  /**\n', '   * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair\n', '   * @dev This batchBurn method does not implement the most efficient way of updating\n', '   *      balances to reduce the potential bug surface as this function is expected to\n', '   *      be less common than transfers. EIP-2200 makes this method significantly\n', '   *      more efficient already for packed balances.\n', '   * @param _from     The address to burn tokens from\n', '   * @param _ids      Array of token ids to burn\n', '   * @param _amounts  Array of the amount to be burned\n', '   */\n', '  function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)\n', '    internal\n', '  {\n', '    // Number of burning to execute\n', '    uint256 nBurn = _ids.length;\n', '    require(nBurn == _amounts.length, "ERC1155MintBurnPackedBalance#batchBurn: INVALID_ARRAYS_LENGTH");\n', '\n', '    // Executing all burning\n', '    for (uint256 i = 0; i < nBurn; i++) {\n', '      // Update storage balance\n', '      _updateIDBalance(_from,   _ids[i], _amounts[i], Operations.Sub); // Add amount to recipient\n', '    }\n', '\n', '    // Emit batch burn event\n', '    emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity 0.8.3;\n', '\n', '\n', 'interface IERC1155Metadata {\n', '\n', '  event URI(string _uri, uint256 indexed _id);\n', '\n', '  /****************************************|\n', '  |                Functions               |\n', '  |_______________________________________*/\n', '\n', '  /**\n', '   * @notice A distinct Uniform Resource Identifier (URI) for a given token.\n', '   * @dev URIs are defined in RFC 3986.\n', '   *      URIs are assumed to be deterministically generated based on token ID\n', '   *      Token IDs are assumed to be represented in their hex format in URIs\n', '   * @return URI string\n', '   */\n', '  function uri(uint256 _id) external view returns (string memory);\n', '}\n', '\n', '// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity 0.8.3;\n', '\n', 'import "../interfaces/IERC1155TokenReceiver.sol";\n', 'import "../interfaces/IERC1155.sol";\n', 'import "../utils/Address.sol";\n', 'import "../utils/ERC165.sol";\n', '\n', '\n', '/**\n', ' * @dev Implementation of Multi-Token Standard contract. This implementation of the ERC-1155 standard\n', ' *      utilizes the fact that balances of different token ids can be concatenated within individual\n', ' *      uint256 storage slots. This allows the contract to batch transfer tokens more efficiently at\n', ' *      the cost of limiting the maximum token balance each address can hold. This limit is\n', ' *      2^IDS_BITS_SIZE, which can be adjusted below. In practice, using IDS_BITS_SIZE smaller than 16\n', ' *      did not lead to major efficiency gains.\n', ' */\n', 'contract ERC1155PackedBalance is IERC1155, ERC165 {\n', '  using Address for address;\n', '\n', '  /***********************************|\n', '  |        Variables and Events       |\n', '  |__________________________________*/\n', '\n', '  // onReceive function signatures\n', '  bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;\n', '  bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;\n', '\n', '  // Constants regarding bin sizes for balance packing\n', '  // IDS_BITS_SIZE **MUST** be a power of 2 (e.g. 2, 4, 8, 16, 32, 64, 128)\n', '  uint256 internal constant IDS_BITS_SIZE   = 32;                  // Max balance amount in bits per token ID\n', '  uint256 internal constant IDS_PER_UINT256 = 256 / IDS_BITS_SIZE; // Number of ids per uint256\n', '\n', '  // Operations for _updateIDBalance\n', '  enum Operations { Add, Sub }\n', '\n', '  // Token IDs balances ; balances[address][id] => balance (using array instead of mapping for efficiency)\n', '  mapping (address => mapping(uint256 => uint256)) internal balances;\n', '\n', '  // Operators\n', '  mapping (address => mapping(address => bool)) internal operators;\n', '\n', '\n', '  /***********************************|\n', '  |     Public Transfer Functions     |\n', '  |__________________________________*/\n', '\n', '  /**\n', '   * @notice Transfers amount amount of an _id from the _from address to the _to address specified\n', '   * @param _from    Source address\n', '   * @param _to      Target address\n', '   * @param _id      ID of the token type\n', '   * @param _amount  Transfered amount\n', '   * @param _data    Additional data with no specified format, sent in call to `_to`\n', '   */\n', '  function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)\n', '    public override\n', '  {\n', '    // Requirements\n', '    require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155PackedBalance#safeTransferFrom: INVALID_OPERATOR");\n', '    require(_to != address(0),"ERC1155PackedBalance#safeTransferFrom: INVALID_RECIPIENT");\n', '    // require(_amount <= balances);  Not necessary since checked with _viewUpdateBinValue() checks\n', '\n', '    _safeTransferFrom(_from, _to, _id, _amount);\n', '    _callonERC1155Received(_from, _to, _id, _amount, gasleft(), _data);\n', '  }\n', '\n', '  /**\n', '   * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)\n', '   * @dev Arrays should be sorted so that all ids in a same storage slot are adjacent (more efficient)\n', '   * @param _from     Source addresses\n', '   * @param _to       Target addresses\n', '   * @param _ids      IDs of each token type\n', '   * @param _amounts  Transfer amounts per token type\n', '   * @param _data     Additional data with no specified format, sent in call to `_to`\n', '   */\n', '  function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)\n', '    public override\n', '  {\n', '    // Requirements\n', '    require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155PackedBalance#safeBatchTransferFrom: INVALID_OPERATOR");\n', '    require(_to != address(0),"ERC1155PackedBalance#safeBatchTransferFrom: INVALID_RECIPIENT");\n', '\n', '    _safeBatchTransferFrom(_from, _to, _ids, _amounts);\n', '    _callonERC1155BatchReceived(_from, _to, _ids, _amounts, gasleft(), _data);\n', '  }\n', '\n', '\n', '  /***********************************|\n', '  |    Internal Transfer Functions    |\n', '  |__________________________________*/\n', '\n', '  /**\n', '   * @notice Transfers amount amount of an _id from the _from address to the _to address specified\n', '   * @param _from    Source address\n', '   * @param _to      Target address\n', '   * @param _id      ID of the token type\n', '   * @param _amount  Transfered amount\n', '   */\n', '  function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)\n', '    internal\n', '  {\n', '    //Update balances\n', '    _updateIDBalance(_from, _id, _amount, Operations.Sub); // Subtract amount from sender\n', '    _updateIDBalance(_to,   _id, _amount, Operations.Add); // Add amount to recipient\n', '\n', '    // Emit event\n', '    emit TransferSingle(msg.sender, _from, _to, _id, _amount);\n', '  }\n', '\n', '  /**\n', '   * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)\n', '   */\n', '  function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, uint256 _gasLimit, bytes memory _data)\n', '    internal\n', '  {\n', '    // Check if recipient is contract\n', '    if (_to.isContract()) {\n', '      bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received{gas:_gasLimit}(msg.sender, _from, _id, _amount, _data);\n', '      require(retval == ERC1155_RECEIVED_VALUE, "ERC1155PackedBalance#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)\n', '   * @dev Arrays should be sorted so that all ids in a same storage slot are adjacent (more efficient)\n', '   * @param _from     Source addresses\n', '   * @param _to       Target addresses\n', '   * @param _ids      IDs of each token type\n', '   * @param _amounts  Transfer amounts per token type\n', '   */\n', '  function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)\n', '    internal\n', '  {\n', '    uint256 nTransfer = _ids.length; // Number of transfer to execute\n', '    require(nTransfer == _amounts.length, "ERC1155PackedBalance#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");\n', '\n', '    if (_from != _to && nTransfer > 0) {\n', '      // Load first bin and index where the token ID balance exists\n', '      (uint256 bin, uint256 index) = getIDBinIndex(_ids[0]);\n', '\n', '      // Balance for current bin in memory (initialized with first transfer)\n', '      uint256 balFrom = _viewUpdateBinValue(balances[_from][bin], index, _amounts[0], Operations.Sub);\n', '      uint256 balTo = _viewUpdateBinValue(balances[_to][bin], index, _amounts[0], Operations.Add);\n', '\n', '      // Last bin updated\n', '      uint256 lastBin = bin;\n', '\n', '      for (uint256 i = 1; i < nTransfer; i++) {\n', '        (bin, index) = getIDBinIndex(_ids[i]);\n', '\n', '        // If new bin\n', '        if (bin != lastBin) {\n', '          // Update storage balance of previous bin\n', '          balances[_from][lastBin] = balFrom;\n', '          balances[_to][lastBin] = balTo;\n', '\n', '          balFrom = balances[_from][bin];\n', '          balTo = balances[_to][bin];\n', '\n', '          // Bin will be the most recent bin\n', '          lastBin = bin;\n', '        }\n', '\n', '        // Update memory balance\n', '        balFrom = _viewUpdateBinValue(balFrom, index, _amounts[i], Operations.Sub);\n', '        balTo = _viewUpdateBinValue(balTo, index, _amounts[i], Operations.Add);\n', '      }\n', '\n', '      // Update storage of the last bin visited\n', '      balances[_from][bin] = balFrom;\n', '      balances[_to][bin] = balTo;\n', '\n', '    // If transfer to self, just make sure all amounts are valid\n', '    } else {\n', '      for (uint256 i = 0; i < nTransfer; i++) {\n', '        require(balanceOf(_from, _ids[i]) >= _amounts[i], "ERC1155PackedBalance#_safeBatchTransferFrom: UNDERFLOW");\n', '      }\n', '    }\n', '\n', '    // Emit event\n', '    emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);\n', '  }\n', '\n', '  /**\n', '   * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)\n', '   */\n', '  function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, uint256 _gasLimit, bytes memory _data)\n', '    internal\n', '  {\n', '    // Pass data if recipient is contract\n', '    if (_to.isContract()) {\n', '      bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived{gas: _gasLimit}(msg.sender, _from, _ids, _amounts, _data);\n', '      require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155PackedBalance#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");\n', '    }\n', '  }\n', '\n', '\n', '  /***********************************|\n', '  |         Operator Functions        |\n', '  |__________________________________*/\n', '\n', '  /**\n', '   * @notice Enable or disable approval for a third party ("operator") to manage all of caller\'s tokens\n', '   * @param _operator  Address to add to the set of authorized operators\n', '   * @param _approved  True if the operator is approved, false to revoke approval\n', '   */\n', '  function setApprovalForAll(address _operator, bool _approved)\n', '    external override\n', '  {\n', '    // Update operator status\n', '    operators[msg.sender][_operator] = _approved;\n', '    emit ApprovalForAll(msg.sender, _operator, _approved);\n', '  }\n', '\n', '  /**\n', '   * @notice Queries the approval status of an operator for a given owner\n', '   * @param _owner     The owner of the Tokens\n', '   * @param _operator  Address of authorized operator\n', '   * @return isOperator True if the operator is approved, false if not\n', '   */\n', '  function isApprovedForAll(address _owner, address _operator)\n', '    public override view returns (bool isOperator)\n', '  {\n', '    return operators[_owner][_operator];\n', '  }\n', '\n', '\n', '  /***********************************|\n', '  |     Public Balance Functions      |\n', '  |__________________________________*/\n', '\n', '  /**\n', "   * @notice Get the balance of an account's Tokens\n", '   * @param _owner  The address of the token holder\n', '   * @param _id     ID of the Token\n', "   * @return The _owner's balance of the Token type requested\n", '   */\n', '  function balanceOf(address _owner, uint256 _id)\n', '    public override view returns (uint256)\n', '  {\n', '    uint256 bin;\n', '    uint256 index;\n', '\n', '    //Get bin and index of _id\n', '    (bin, index) = getIDBinIndex(_id);\n', '    return getValueInBin(balances[_owner][bin], index);\n', '  }\n', '\n', '  /**\n', '   * @notice Get the balance of multiple account/token pairs\n', '   * @param _owners The addresses of the token holders (sorted owners will lead to less gas usage)\n', '   * @param _ids    ID of the Tokens (sorted ids will lead to less gas usage\n', "   * @return The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)\n", '    */\n', '  function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)\n', '    public override view returns (uint256[] memory)\n', '  {\n', '    uint256 n_owners = _owners.length;\n', '    require(n_owners == _ids.length, "ERC1155PackedBalance#balanceOfBatch: INVALID_ARRAY_LENGTH");\n', '\n', '    // First values\n', '    (uint256 bin, uint256 index) = getIDBinIndex(_ids[0]);\n', '    uint256 balance_bin = balances[_owners[0]][bin];\n', '    uint256 last_bin = bin;\n', '\n', '    // Initialization\n', '    uint256[] memory batchBalances = new uint256[](n_owners);\n', '    batchBalances[0] = getValueInBin(balance_bin, index);\n', '\n', '    // Iterate over each owner and token ID\n', '    for (uint256 i = 1; i < n_owners; i++) {\n', '      (bin, index) = getIDBinIndex(_ids[i]);\n', '\n', '      // SLOAD if bin changed for the same owner or if owner changed\n', '      if (bin != last_bin || _owners[i-1] != _owners[i]) {\n', '        balance_bin = balances[_owners[i]][bin];\n', '        last_bin = bin;\n', '      }\n', '\n', '      batchBalances[i] = getValueInBin(balance_bin, index);\n', '    }\n', '\n', '    return batchBalances;\n', '  }\n', '\n', '\n', '  /***********************************|\n', '  |      Packed Balance Functions     |\n', '  |__________________________________*/\n', '\n', '  /**\n', '   * @notice Update the balance of a id for a given address\n', '   * @param _address    Address to update id balance\n', '   * @param _id         Id to update balance of\n', '   * @param _amount     Amount to update the id balance\n', '   * @param _operation  Which operation to conduct :\n', '   *   Operations.Add: Add _amount to id balance\n', '   *   Operations.Sub: Substract _amount from id balance\n', '   */\n', '  function _updateIDBalance(address _address, uint256 _id, uint256 _amount, Operations _operation)\n', '    internal\n', '  {\n', '    uint256 bin;\n', '    uint256 index;\n', '\n', '    // Get bin and index of _id\n', '    (bin, index) = getIDBinIndex(_id);\n', '\n', '    // Update balance\n', '    balances[_address][bin] = _viewUpdateBinValue(balances[_address][bin], index, _amount, _operation);\n', '  }\n', '\n', '  /**\n', '   * @notice Update a value in _binValues\n', '   * @param _binValues  Uint256 containing values of size IDS_BITS_SIZE (the token balances)\n', '   * @param _index      Index of the value in the provided bin\n', '   * @param _amount     Amount to update the id balance\n', '   * @param _operation  Which operation to conduct :\n', '   *   Operations.Add: Add _amount to value in _binValues at _index\n', '   *   Operations.Sub: Substract _amount from value in _binValues at _index\n', '   */\n', '  function _viewUpdateBinValue(uint256 _binValues, uint256 _index, uint256 _amount, Operations _operation)\n', '    internal pure returns (uint256 newBinValues)\n', '  {\n', '    uint256 shift = IDS_BITS_SIZE * _index;\n', '    uint256 mask = (uint256(1) << IDS_BITS_SIZE) - 1;\n', '\n', '    if (_operation == Operations.Add) {\n', '      newBinValues = _binValues + (_amount << shift);\n', '      require(newBinValues >= _binValues, "ERC1155PackedBalance#_viewUpdateBinValue: OVERFLOW");\n', '      require(\n', '        ((_binValues >> shift) & mask) + _amount < 2**IDS_BITS_SIZE, // Checks that no other id changed\n', '        "ERC1155PackedBalance#_viewUpdateBinValue: OVERFLOW"\n', '      );\n', '\n', '    } else if (_operation == Operations.Sub) {\n', '      newBinValues = _binValues - (_amount << shift);\n', '      require(newBinValues <= _binValues, "ERC1155PackedBalance#_viewUpdateBinValue: UNDERFLOW");\n', '      require(\n', '        ((_binValues >> shift) & mask) >= _amount, // Checks that no other id changed\n', '        "ERC1155PackedBalance#_viewUpdateBinValue: UNDERFLOW"\n', '      );\n', '\n', '    } else {\n', '      revert("ERC1155PackedBalance#_viewUpdateBinValue: INVALID_BIN_WRITE_OPERATION"); // Bad operation\n', '    }\n', '\n', '    return newBinValues;\n', '  }\n', '\n', '  /**\n', '  * @notice Return the bin number and index within that bin where ID is\n', '  * @param _id  Token id\n', '  * @return bin index (Bin number, ID"s index within that bin)\n', '  */\n', '  function getIDBinIndex(uint256 _id)\n', '    public pure returns (uint256 bin, uint256 index)\n', '  {\n', '    bin = _id / IDS_PER_UINT256;\n', '    index = _id % IDS_PER_UINT256;\n', '    return (bin, index);\n', '  }\n', '\n', '  /**\n', '   * @notice Return amount in _binValues at position _index\n', '   * @param _binValues  uint256 containing the balances of IDS_PER_UINT256 ids\n', '   * @param _index      Index at which to retrieve amount\n', '   * @return amount at given _index in _bin\n', '   */\n', '  function getValueInBin(uint256 _binValues, uint256 _index)\n', '    public pure returns (uint256)\n', '  {\n', '    // require(_index < IDS_PER_UINT256) is not required since getIDBinIndex ensures `_index < IDS_PER_UINT256`\n', '\n', '    // Mask to retrieve data for a given binData\n', '    uint256 mask = (uint256(1) << IDS_BITS_SIZE) - 1;\n', '\n', '    // Shift amount\n', '    uint256 rightShift = IDS_BITS_SIZE * _index;\n', '    return (_binValues >> rightShift) & mask;\n', '  }\n', '\n', '\n', '  /***********************************|\n', '  |          ERC165 Functions         |\n', '  |__________________________________*/\n', '\n', '  /**\n', '   * @notice Query if a contract implements an interface\n', '   * @param _interfaceID  The interface identifier, as specified in ERC-165\n', '   * @return `true` if the contract implements `_interfaceID` and\n', '   */\n', '  function supportsInterface(bytes4 _interfaceID) public override virtual pure returns (bool) {\n', '    if (_interfaceID == type(IERC1155).interfaceId) {\n', '      return true;\n', '    }\n', '    return super.supportsInterface(_interfaceID);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity 0.8.3;\n', '\n', '/**\n', ' * @dev ERC-1155 interface for accepting safe transfers.\n', ' */\n', 'interface IERC1155TokenReceiver {\n', '\n', '  /**\n', '   * @notice Handle the receipt of a single ERC1155 token type\n', '   * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated\n', '   * This function MAY throw to revert and reject the transfer\n', '   * Return of other amount than the magic value MUST result in the transaction being reverted\n', '   * Note: The token contract address is always the message sender\n', '   * @param _operator  The address which called the `safeTransferFrom` function\n', '   * @param _from      The address which previously owned the token\n', '   * @param _id        The id of the token being transferred\n', '   * @param _amount    The amount of tokens being transferred\n', '   * @param _data      Additional data with no specified format\n', '   * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '   */\n', '  function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);\n', '\n', '  /**\n', '   * @notice Handle the receipt of multiple ERC1155 token types\n', '   * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated\n', '   * This function MAY throw to revert and reject the transfer\n', '   * Return of other amount than the magic value WILL result in the transaction being reverted\n', '   * Note: The token contract address is always the message sender\n', '   * @param _operator  The address which called the `safeBatchTransferFrom` function\n', '   * @param _from      The address which previously owned the token\n', '   * @param _ids       An array containing ids of each token being transferred\n', '   * @param _amounts   An array containing amounts of each token being transferred\n', '   * @param _data      Additional data with no specified format\n', '   * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '   */\n', '  function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);\n', '}\n', '\n', '// SPDX-License-Identifier: Apache-2.0\n', 'pragma solidity 0.8.3;\n', '\n', '\n', 'interface IERC1155 {\n', '\n', '  /****************************************|\n', '  |                 Events                 |\n', '  |_______________________________________*/\n', '\n', '  /**\n', '   * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning\n', '   *   Operator MUST be msg.sender\n', '   *   When minting/creating tokens, the `_from` field MUST be set to `0x0`\n', '   *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`\n', '   *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID\n', '   *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0\n', '   */\n', '  event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);\n', '\n', '  /**\n', '   * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning\n', '   *   Operator MUST be msg.sender\n', '   *   When minting/creating tokens, the `_from` field MUST be set to `0x0`\n', '   *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`\n', '   *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID\n', '   *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0\n', '   */\n', '  event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);\n', '\n', '  /**\n', '   * @dev MUST emit when an approval is updated\n', '   */\n', '  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);\n', '\n', '\n', '  /****************************************|\n', '  |                Functions               |\n', '  |_______________________________________*/\n', '\n', '  /**\n', '    * @notice Transfers amount of an _id from the _from address to the _to address specified\n', '    * @dev MUST emit TransferSingle event on success\n', "    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)\n", '    * MUST throw if `_to` is the zero address\n', '    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent\n', '    * MUST throw on any other error\n', '    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`\n', '    * @param _from    Source address\n', '    * @param _to      Target address\n', '    * @param _id      ID of the token type\n', '    * @param _amount  Transfered amount\n', '    * @param _data    Additional data with no specified format, sent in call to `_to`\n', '    */\n', '  function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;\n', '\n', '  /**\n', '    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)\n', '    * @dev MUST emit TransferBatch event on success\n', "    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)\n", '    * MUST throw if `_to` is the zero address\n', '    * MUST throw if length of `_ids` is not the same as length of `_amounts`\n', '    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent\n', '    * MUST throw on any other error\n', '    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`\n', '    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)\n', '    * @param _from     Source addresses\n', '    * @param _to       Target addresses\n', '    * @param _ids      IDs of each token type\n', '    * @param _amounts  Transfer amounts per token type\n', '    * @param _data     Additional data with no specified format, sent in call to `_to`\n', '  */\n', '  function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;\n', '\n', '  /**\n', "   * @notice Get the balance of an account's Tokens\n", '   * @param _owner  The address of the token holder\n', '   * @param _id     ID of the Token\n', "   * @return        The _owner's balance of the Token type requested\n", '   */\n', '  function balanceOf(address _owner, uint256 _id) external view returns (uint256);\n', '\n', '  /**\n', '   * @notice Get the balance of multiple account/token pairs\n', '   * @param _owners The addresses of the token holders\n', '   * @param _ids    ID of the Tokens\n', "   * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)\n", '   */\n', '  function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);\n', '\n', '  /**\n', '   * @notice Enable or disable approval for a third party ("operator") to manage all of caller\'s tokens\n', '   * @dev MUST emit the ApprovalForAll event on success\n', '   * @param _operator  Address to add to the set of authorized operators\n', '   * @param _approved  True if the operator is approved, false to revoke approval\n', '   */\n', '  function setApprovalForAll(address _operator, bool _approved) external;\n', '\n', '  /**\n', '   * @notice Queries the approval status of an operator for a given owner\n', '   * @param _owner     The owner of the Tokens\n', '   * @param _operator  Address of authorized operator\n', '   * @return isOperator True if the operator is approved, false if not\n', '   */\n', '  function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.8.3;\n', '\n', '\n', '/**\n', ' * Utility library of inline functions on addresses\n', ' */\n', 'library Address {\n', '\n', '  // Default hash for EOA accounts returned by extcodehash\n', '  bytes32 constant internal ACCOUNT_HASH = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '\n', '  /**\n', '   * Returns whether the target address is a contract\n', '   * @dev This function will return false if invoked during the constructor of a contract.\n', '   * @param _address address of the account to check\n', '   * @return Whether the target address is a contract\n', '   */\n', '  function isContract(address _address) internal view returns (bool) {\n', '    bytes32 codehash;\n', '\n', '    // Currently there is no better way to check if there is a contract in an address\n', '    // than to check the size of the code at that address or if it has a non-zero code hash or account hash\n', '    assembly { codehash := extcodehash(_address) }\n', '    return (codehash != 0x0 && codehash != ACCOUNT_HASH);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', 'pragma solidity 0.8.3;\n', '\n', 'abstract contract ERC165 {\n', '  /**\n', '   * @notice Query if a contract implements an interface\n', '   * @param _interfaceID The interface identifier, as specified in ERC-165\n', '   * @return `true` if the contract implements `_interfaceID`\n', '   */\n', '  function supportsInterface(bytes4 _interfaceID) virtual public pure returns (bool) {\n', '    return _interfaceID == this.supportsInterface.selector;\n', '  }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 100000,\n', '    "details": {\n', '      "yul": true,\n', '      "constantOptimizer": false\n', '    }\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']