// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol';
import '@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol';

/**
 * @notice A Chainlink VRF consumer which uses randomness to mimic the rolling
 * of a 20 sided dice
 */
 /**
     * 
     * Network: Mumbai
     * Chainlink VRF Coordinator address: 0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
     * LINK token address:                0x326C977E6efc84E512bB9C30f76E30c160eD06FB
     * Key Hash: 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
     *
     *
     * 
     * Network: Matic Mainnet
     * Chainlink VRF Coordinator address: 0x3d2341ADb2D31f1c5530cDC622016af293177AE0
     * LINK token address:                0xb0897686c545045aFc77CF20eC7A532E3120E0F1
     * Key Hash: 0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da
     */
interface interfaceVRFD20 { function mapCheck(address player) external view returns (bool); } 

contract VRFD20 is VRFConsumerBaseV2 {
    uint256 private constant ROLL_IN_PROGRESS = 42;

    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 s_subscriptionId;

    // Rinkeby coordinator. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 s_keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 40,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 40000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 1 random value in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 1;
    address s_owner;

    // map rollers to requestIds
    mapping(uint256 => address) private s_rollers;
    // map vrf results to rollers
    mapping(address => uint256) private s_results;

    // map vrf results to FUD rollers
    mapping(address => uint256) private s_FUDresults;
    // map vrf results to FOMO rollers
    mapping(address => uint256) private s_FOMOresults;
    // map vrf results to ALPHA rollers
    mapping(address => uint256) private s_ALPHAresults;
    // map vrf results to KEK rollers
    mapping(address => uint256) private s_KEKresults;
    // map vrf results to GLTR rollers
    mapping(address => uint256) private s_GLTRresults;

    event DiceRolled(uint256 indexed requestId, address indexed roller);
    event DiceLanded(uint256 indexed requestId, uint256 indexed result);

    //Alchemica token addresses
    address GLTR = 0x3801C3B3B5c98F88a9c9005966AA96aa440B9Afc;
    address FUD = 0x403E967b044d4Be25170310157cB1A4Bf10bdD0f;
    address ALPHA = 0x6a3E7C3c6EF65Ee26975b12293cA1AAD7e1dAeD2;
    address FOMO = 0x44A6e0BE76e1D9620A7F76588e4509fE4fa8E8C8;
    address KEK = 0x42E5E06EF5b90Fe15F853F59299Fc96259209c5C;

    /**
     * @notice Constructor inherits VRFConsumerBaseV2
     *
     * @dev NETWORK: RINKEBY
     *
     * @param subscriptionId subscription id that this consumer contract can use
     */
    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender; //hardcode proxy
        s_subscriptionId = subscriptionId;
    }

    /**
     * @notice Requests randomness
     * @dev Warning: if the VRF response is delayed, avoid calling requestRandomness repeatedly
     * as that would give miners/VRF operators latitude about which VRF response arrives first.
     * @dev You must review your implementation details with extreme care.
     *
     * @param roller address of the roller
     */
    function rollDice(address roller) public onlyOwner returns (uint256 requestId) { //remove onlyOwner to allow public calls from others, if desired
        require(s_results[roller] == 0, 'Already rolled'); //delete to allow reroll?
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        s_rollers[requestId] = roller;
        s_results[roller] = ROLL_IN_PROGRESS;
        emit DiceRolled(requestId, roller);
    }

    /**
     * @notice Callback function used by VRF Coordinator to return the random number to this contract.
     *
     * @dev Some action on the contract state should be taken here, like storing the result.
     * @dev WARNING: take care to avoid having multiple VRF requests in flight if their order of arrival would result
     * in contract states with different outcomes. Otherwise miners or the VRF operator would could take advantage
     * by controlling the order.
     * @dev The VRF Coordinator will only send this function verified responses, and the parent VRFConsumerBaseV2
     * contract ensures that this method only receives randomness from the designated VRFCoordinator.
     *
     * @param requestId uint256
     * @param randomWords  uint256[] The random result returned by the oracle.
     */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        uint256 d20Value = (randomWords[0] % 20) + 1;
        s_results[s_rollers[requestId]] = d20Value;
        emit DiceLanded(requestId, d20Value);
    }

    /**
     * @notice Get the house assigned to the player once the address has rolled
     * @param player address
     * @return house as a string
     */
    function house(address player) public view returns (string memory) {
        require(s_results[player] != 0, 'Dice not rolled');
        require(s_results[player] != ROLL_IN_PROGRESS, 'Roll in progress');  //change to allow multiple rolls?
        return getHouseName(s_results[player]);
    }
    /**
     * @notice Checks to see if the address has rolled
     * @param player address
     * @return bool
     */
    function mapCheck(address player) external view returns (bool) {  //msg.sender?
        require(s_results[player] != 0, 'Dice not rolled'); // incorrect equivalance
        return true;
    }

    /**
     * @notice Get the fortune for players that input FUD
     * @param id uint256
     * @return fortune string
     */
    function getFortuneFUD(uint256 id) private pure returns (string memory) {
        string[20] memory houseNames = [
            '$...$FUD?...NGMI....', 
            'Lannister',
            'Stark',
            'Tyrell',
            'Baratheon',
            'Martell',
            'Tully',
            'Bolton',
            'Greyjoy',
            'Arryn',
            'Frey',
            'Mormont',
            'Tarley',
            'Dayne',
            'Umber',
            'Valeryon',
            'Manderly',
            'Clegane',
            'Glover',
            'Karstark'
        ];
        return houseNames[id - 1];
    }
    /**
     * @notice Get the fortune for players that input FOMO
     * @param id uint256
     * @return fortune string
     */
    function getFortuneFOMO(uint256 id) private pure returns (string memory) {
        string[20] memory houseNames = [
            'do not FOMO into the grid alone, or else be lickquidated',
            'Lannister',
            'Stark',
            'Tyrell',
            'Baratheon',
            'Martell',
            'Tully',
            'Bolton',
            'Greyjoy',
            'Arryn',
            'Frey',
            'Mormont',
            'Tarley',
            'Dayne',
            'Umber',
            'Valeryon',
            'Manderly',
            'Clegane',
            'Glover',
            'Karstark'
        ];
        return houseNames[id - 1];
    }
    /**
     * @notice Get the fortune for players that input ALPHA
     * @param id uint256
     * @return fortune string
     */
    function getFortuneALPHA(uint256 id) private pure returns (string memory) {
        string[20] memory houseNames = [
            'Its Alpha that you seek...',
            'Lannister',
            'Stark',
            'Tyrell',
            'Baratheon',
            'Martell',
            'Tully',
            'Bolton',
            'Greyjoy',
            'Arryn',
            'Frey',
            'Mormont',
            'Tarley',
            'Dayne',
            'Umber',
            'Valeryon',
            'Manderly',
            'Clegane',
            'Glover',
            'Karstark'
        ];
        return houseNames[id - 1];
    }
    /**
     * @notice Get the fortune for players that input KEK
     * @param id uint256
     * @return fortune string
     */
    function getFortuneKEK(uint256 id) private pure returns (string memory) {
        string[20] memory houseNames = [
            'You fren, GMI',
            'If you can handle the grid, the spillover is yours',
            'KEK',
            'Tyrell',
            'Baratheon',
            'Martell',
            'Tully',
            'Bolton',
            'Greyjoy',
            'Arryn',
            'Frey',
            'Mormont',
            'Tarley',
            'Dayne',
            'Umber',
            'Valeryon',
            'Manderly',
            'Clegane',
            'Glover',
            'Karstark'
        ];
        return houseNames[id - 1];
    } 
    function getFortuneGLTR(uint256 id) private pure returns (string memory) {
        string[20] memory houseNames = [
            'You are a true buidler, I can tell by your coin',
            'One might say, a true Chad would tokenize time itself',
            'Stark',
            'Tyrell',
            'Baratheon',
            'Martell',
            'Tully',
            'Bolton',
            'Greyjoy',
            'Arryn',
            'Frey',
            'Mormont',
            'Tarley',
            'Dayne',
            'Umber',
            'Valeryon',
            'Manderly',
            'Clegane',
            'Glover',
            'Karstark'
        ];
        return houseNames[id - 1];
    }
    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    // implement counter/incr, to stop accepting payments after NFT Item of each kind is minted out**
}