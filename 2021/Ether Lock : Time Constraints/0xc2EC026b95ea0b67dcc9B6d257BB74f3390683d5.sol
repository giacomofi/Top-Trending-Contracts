['// SPDX-License-Identifier: P-P-P-PONZO!!!\n', 'pragma solidity ^0.7.4;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '/* ROOTKIT:\n', 'A transfer gate (GatedERC20) for use with RootKit tokens\n', '\n', 'It:\n', '    Allows customization of tax and burn rates\n', '    Allows transfer to/from approved Uniswap pools\n', '    Disallows transfer to/from non-approved Uniswap pools\n', '    Allows transfer to/from anywhere else\n', '    Allows for free transfers if permission granted\n', '    Allows for unrestricted transfers if permission granted\n', '    Provides a safe and tax-free liquidity adding function\n', '*/\n', '\n', 'import "./Owned.sol";\n', 'import "./IUniswapV2Factory.sol";\n', 'import "./IERC20.sol";\n', 'import "./IUniswapV2Pair.sol";\n', 'import "./EliteToken.sol";\n', 'import "./Address.sol";\n', 'import "./IUniswapV2Router02.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./TokensRecoverable.sol";\n', 'import "./ITransferGate.sol";\n', 'import "./FeeSplitter.sol";\n', '\n', 'contract RootedTransferGate is TokensRecoverable, ITransferGate\n', '{   \n', '    using Address for address;\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    enum AddressState\n', '    {\n', '        Unknown,\n', '        NotPool,\n', '        DisallowedPool,\n', '        AllowedPool\n', '    }\n', '\n', '    IUniswapV2Router02 immutable internal uniswapV2Router;\n', '    IUniswapV2Factory immutable internal uniswapV2Factory;\n', '    IERC31337 immutable internal rootedToken;\n', '\n', '    mapping (address => AddressState) public addressStates;\n', '    IERC20[] public allowedPoolTokens;\n', '    \n', '    bool public unrestricted;\n', '    mapping (address => bool) public unrestrictedControllers;\n', '    mapping (address => bool) public feeControllers;\n', '    mapping (address => bool) public freeParticipantControllers;\n', '    mapping (address => bool) public freeParticipant;\n', '\n', '    mapping (address => uint256) public liquiditySupply;\n', '    address public mustUpdate;\n', '\n', '    FeeSplitter feeSplitter;\n', '    uint16 public feesRate; \n', '    uint16 public sellFeesRate; \n', '    uint16 public startTaxRate; \n', '    uint256 public durationInSeconds;\n', '    uint256 public endTimestamp;\n', '\n', '    constructor(IERC31337 _rootedToken, IUniswapV2Router02 _uniswapV2Router)\n', '    {\n', '        rootedToken = _rootedToken;\n', '        uniswapV2Router = _uniswapV2Router;\n', '        uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());\n', '    }\n', '\n', '    function allowedPoolTokensCount() public view returns (uint256) { return allowedPoolTokens.length; }\n', '\n', '    function setUnrestrictedController(address unrestrictedController, bool allow) public ownerOnly()\n', '    {\n', '        unrestrictedControllers[unrestrictedController] = allow;\n', '    }\n', '\n', '    function setFreeParticipantController(address freeParticipantController, bool allow) public ownerOnly()\n', '    {\n', '        freeParticipantControllers[freeParticipantController] = allow;\n', '    }\n', '\n', '    function setFeeControllers(address feeController, bool allow) public ownerOnly()\n', '    {\n', '        feeControllers[feeController] = allow;\n', '    }\n', '\n', '    function setFeeSplitter(FeeSplitter _feeSplitter) public ownerOnly()\n', '    {\n', '        feeSplitter = _feeSplitter;\n', '    }\n', '\n', '    function setFreeParticipant(address participant, bool free) public\n', '    {\n', '        require (msg.sender == owner || freeParticipantControllers[msg.sender], "Not an Owner or Free Participant");\n', '        freeParticipant[participant] = free;\n', '    }\n', '\n', '    function setUnrestricted(bool _unrestricted) public\n', '    {\n', '        require (unrestrictedControllers[msg.sender], "Not an unrestricted controller");\n', '        unrestricted = _unrestricted;\n', '    }    \n', '\n', '    function setDumpTax(uint16 _startTaxRate, uint256 _durationInSeconds) public\n', '    {\n', '        require (feeControllers[msg.sender] || msg.sender == owner, "Not an owner or fee controller");\n', '        require (_startTaxRate <= 1000, "Fee rate should be less than or equal to 10%");\n', '\n', '        startTaxRate = _startTaxRate;\n', '        durationInSeconds = _durationInSeconds;\n', '        endTimestamp = block.timestamp + durationInSeconds;\n', '    }\n', '\n', '    function getDumpTax() public view returns (uint256)\n', '    {\n', '        if (block.timestamp >= endTimestamp) \n', '        {\n', '            return 0;\n', '        }\n', '        \n', '        return startTaxRate*(endTimestamp - block.timestamp).mul(1e12).div(durationInSeconds).div(1e12);\n', '    }\n', '\n', '    function setFees(uint16 _feesRate) public\n', '    {\n', '        require (feeControllers[msg.sender] || msg.sender == owner, "Not an owner or fee controller");\n', '        require (_feesRate <= 500, "> 5%"); // protecting everyone from Ponzo\n', '        \n', '        feesRate = _feesRate;\n', '    }\n', '    \n', '    function setSellFees(uint16 _sellFeesRate) public\n', '    {\n', '        require (feeControllers[msg.sender] || msg.sender == owner, "Not an owner or fee controller");\n', '        require (_sellFeesRate <= 2500, "> 25%"); // protecting everyone from Ponzo\n', '        \n', '        sellFeesRate = _sellFeesRate;\n', '    }\n', '\n', '    function allowPool(IERC20 token) public ownerOnly()\n', '    {\n', '        address pool = uniswapV2Factory.getPair(address(rootedToken), address(token));\n', '        if (pool == address(0)) {\n', '            pool = uniswapV2Factory.createPair(address(rootedToken), address(token));\n', '        }\n', '        AddressState state = addressStates[pool];\n', '        require (state != AddressState.AllowedPool, "Already allowed");\n', '        addressStates[pool] = AddressState.AllowedPool;\n', '        allowedPoolTokens.push(token);\n', '        liquiditySupply[pool] = IERC20(pool).totalSupply();\n', '    }\n', '\n', '    function safeAddLiquidity(IERC20 token, uint256 tokenAmount, uint256 rootKitAmount, uint256 minTokenAmount, uint256 minRootKitAmount, address to, uint256 deadline) public\n', '        returns (uint256 rootKitUsed, uint256 tokenUsed, uint256 liquidity)\n', '    {\n', '        address pool = uniswapV2Factory.getPair(address(rootedToken), address(token));\n', '        require (pool != address(0) && addressStates[pool] == AddressState.AllowedPool, "Pool not approved");\n', '        require (!unrestricted);\n', '        unrestricted = true;\n', '\n', '        uint256 tokenBalance = token.balanceOf(address(this));\n', '        token.safeTransferFrom(msg.sender, address(this), tokenAmount);\n', '        rootedToken.transferFrom(msg.sender, address(this), rootKitAmount);\n', '        rootedToken.approve(address(uniswapV2Router), rootKitAmount);\n', '        token.safeApprove(address(uniswapV2Router), tokenAmount);\n', '        (rootKitUsed, tokenUsed, liquidity) = uniswapV2Router.addLiquidity(address(rootedToken), address(token), rootKitAmount, tokenAmount, minRootKitAmount, minTokenAmount, to, deadline);\n', '        liquiditySupply[pool] = IERC20(pool).totalSupply();\n', '        if (mustUpdate == pool) {\n', '            mustUpdate = address(0);\n', '        }\n', '\n', '        if (rootKitUsed < rootKitAmount) {\n', '            rootedToken.transfer(msg.sender, rootKitAmount - rootKitUsed);\n', '        }\n', "        tokenBalance = token.balanceOf(address(this)).sub(tokenBalance); // we do it this way in case there's a burn\n", '        if (tokenBalance > 0) {\n', '            token.safeTransfer(msg.sender, tokenBalance);\n', '        }\n', '        \n', '        unrestricted = false;\n', '    }\n', '\n', '    function handleTransfer(address, address from, address to, uint256 amount) public virtual override returns (address, uint256)\n', '    {\n', '        {\n', '            address mustUpdateAddress = mustUpdate;\n', '            if (mustUpdateAddress != address(0)) {\n', '                mustUpdate = address(0);\n', '                uint256 newSupply = IERC20(mustUpdateAddress).totalSupply();\n', '                uint256 oldSupply = liquiditySupply[mustUpdateAddress];\n', '                if (newSupply != oldSupply) {\n', '                    liquiditySupply[mustUpdateAddress] = unrestricted ? newSupply : (newSupply > oldSupply ? newSupply : oldSupply);\n', '                }\n', '            }\n', '        }\n', '        {\n', '            AddressState fromState = addressStates[from];\n', '            AddressState toState = addressStates[to];\n', '            if (fromState != AddressState.AllowedPool && toState != AddressState.AllowedPool) {\n', '                if (fromState == AddressState.Unknown) { fromState = detectState(from); }\n', '                if (toState == AddressState.Unknown) { toState = detectState(to); }\n', '                require (unrestricted || (fromState != AddressState.DisallowedPool && toState != AddressState.DisallowedPool), "Pool not approved");\n', '            }\n', '            if (toState == AddressState.AllowedPool) {\n', '                mustUpdate = to;\n', '            }\n', '            if (fromState == AddressState.AllowedPool) {\n', '                if (unrestricted) {\n', '                    liquiditySupply[from] = IERC20(from).totalSupply();\n', '                }\n', '                require (IERC20(from).totalSupply() >= liquiditySupply[from], "Cannot remove liquidity");            \n', '            }\n', '        }\n', '        if (unrestricted || freeParticipant[from] || freeParticipant[to]) {\n', '            return (address(feeSplitter), 0);\n', '        }\n', '        if (to == address(uniswapV2Router)) {\n', '            return (address(feeSplitter), amount * sellFeesRate / 10000 + getDumpTax());\n', '        }\n', '        // "amount" will never be > totalSupply which is capped at 10k, so these multiplications will never overflow      \n', '        return (address(feeSplitter), amount * feesRate / 10000);\n', '    }\n', '\n', '    function setAddressState(address a, AddressState state) public ownerOnly()\n', '    {\n', '        addressStates[a] = state;\n', '    }\n', '\n', '    function detectState(address a) public returns (AddressState state) \n', '    {\n', '        state = AddressState.NotPool;\n', '        if (a.isContract()) {\n', '            try this.throwAddressState(a)\n', '            {\n', '                assert(false);\n', '            }\n', '            catch Error(string memory result) {\n', '                // if (bytes(result).length == 1) {\n', '                //     state = AddressState.NotPool;\n', '                // }\n', '                if (bytes(result).length == 2) {\n', '                    state = AddressState.DisallowedPool;\n', '                }\n', '            }\n', '            catch {\n', '            }\n', '        }\n', '        addressStates[a] = state;\n', '        return state;\n', '    }\n', '    \n', '    // Not intended for external consumption\n', '    // Always throws\n', "    // We want to call functions to probe for things, but don't want to open ourselves up to\n", '    // possible state-changes\n', '    // So we return a value by reverting with a message\n', '    function throwAddressState(address a) external view\n', '    {\n', '        try IUniswapV2Pair(a).factory() returns (address factory)\n', '        {\n', '            if (factory == address(uniswapV2Factory)) {\n', '                // these checks for token0/token1 are just for additional\n', "                // certainty that we're interacting with a uniswap pair\n", '                try IUniswapV2Pair(a).token0() returns (address token0)\n', '                {\n', '                    if (token0 == address(rootedToken)) {\n', '                        revert("22");\n', '                    }\n', '                    try IUniswapV2Pair(a).token1() returns (address token1)\n', '                    {\n', '                        if (token1 == address(rootedToken)) {\n', '                            revert("22");\n', '                        }                        \n', '                    }\n', '                    catch { \n', '                    }                    \n', '                }\n', '                catch { \n', '                }\n', '            }\n', '        }\n', '        catch {             \n', '        }\n', '        revert("1");\n', '    }\n', '}']