#include <atomic>

static_assert(std::atomic<float>::is_always_lock_free, "hxal type AtomicFloat not atomic");

class SineProcessor
{
    private:
    
    float phase;
    
    std::atomic<float> pitch;
    
    public:
};
