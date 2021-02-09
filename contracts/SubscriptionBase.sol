// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/EnumerableMap.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SubscriptionBase is Ownable {

    using SafeMath for uint256;


    /* ========== PUBLIC STATE VARIABLES ========== */
    address public devAddress; 

    uint256 public secondsPerBlock = 15;

    uint256 public subscriptionTime = uint256(15 minutes);

    /* ========== INTERNAL STATE VARIABLES ========== */
    Subscription[] internal subscriptions; 

    EnumerableMap.UintToAddressMap internal SubscriptionsAllowedToAddress; 

    /* ========== SUBSCRIPTION STRUCT ========== */
    struct Subscription {
        // Sub start timestamp
        uint64  startTime; 
        // Sub maximum timestamp
        uint64 endTime; 
    }

     /* ========== VIEW ========== */
    function getTotalSubscriptions() external view returns (uint256) {
        return subscriptions.length;
    }

    /* ========== OWNER MUTATIVE FUNCTION ========== */

    function setDevAddress(address _devAddress) external onlyDev {
        devAddress = _devAddress;
    }

    function setSubscriptionTime(uint64 _subscriptionTime) external onlyDev {
        subscriptionTime = _subscriptionTime;
    }

    function setSecondsPerBlock(uint256 _secs) external onlyOwner {
        secondsPerBlock = _secs;
    }

    /* ========== MODIFIER ========== */

    modifier onlyDev() {
        require(
            devAddress == _msgSender(),
            "Caller is not the dev"
        );
        _;
    }

}