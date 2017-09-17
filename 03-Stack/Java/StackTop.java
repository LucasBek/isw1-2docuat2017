package stack;

public interface StackTop {
	public boolean isEmpty();
	public Integer size();
	public Object content();
	public StackTop previous();
}
